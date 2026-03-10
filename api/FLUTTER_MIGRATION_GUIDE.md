# Flutter Migration Guide — Storybook API Security Hardening Pass

**Audience:** Flutter developers building Android and Windows desktop clients against the Storybook v1 REST API.

**Applies to:** All clients written against the previous API. Every section marked "Breaking" will cause crashes, silent data corruption, or auth failures if not addressed.

---

## 1. Executive Summary

The Storybook backend underwent a security hardening pass. The changes fall into three categories:

1. **Auth tightening** — stronger password validation, short-lived tokens (15 min), and rate limiting on auth endpoints.
2. **Data model corrections** — timestamps changed from Unix millisecond integers to ISO 8601 strings across four models; the `Chapter.content` field was removed from list/get responses and moved to dedicated endpoints.
3. **Sync protocol changes** — push payloads now have a 500-item-per-array cap, tombstones have a new `userId` field, and story updates support optional conflict detection.

There is also one new endpoint (`POST /ai/generic`) that you may want to adopt.

None of the changes require a full rewrite, but **four of them will silently corrupt data or crash at runtime** if ignored. Read the breaking changes in order — they are sorted by severity.

---

## 2. Breaking Changes

### 2.1 Timestamp fields are now ISO 8601 strings, not integers

**Priority: Critical — will crash or silently corrupt data.**

All `createdAt` and `updatedAt` fields that were previously Unix millisecond integers are now ISO 8601 strings (e.g., `"2026-03-10T14:30:00.000Z"`).

**Affected fields:**
- `Story.createdAt`
- `Story.updatedAt`
- `Note.createdAt`
- `UnresolvedQuestion.createdAt`
- `TombstoneRecord.deletedAt` (new field — see section 2.6)

**What breaks:** If your `fromJson` factory casts these fields to `int`, you will get a `TypeError` at runtime. If you use `json['createdAt'] as int` or `(json['createdAt'] as num).toInt()`, it throws. If you silently swallow parse errors, you will get `DateTime` values of epoch zero or garbage data.

**Before:**
```dart
class Story {
  final int createdAt; // Unix milliseconds
  final int updatedAt;

  factory Story.fromJson(Map<String, dynamic> json) => Story(
    createdAt: json['createdAt'] as int,
    updatedAt: json['updatedAt'] as int,
    // ...
  );

  DateTime get createdAtDate =>
      DateTime.fromMillisecondsSinceEpoch(createdAt);
}
```

**After:**
```dart
class Story {
  final String createdAt; // ISO 8601 string
  final String updatedAt;

  factory Story.fromJson(Map<String, dynamic> json) => Story(
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
    // ...
  );

  // Parse to DateTime when you need to sort or display
  DateTime get createdAtDate => DateTime.parse(createdAt);
  DateTime get updatedAtDate => DateTime.parse(updatedAt);
}
```

Apply the same pattern to `Note` and `UnresolvedQuestion`:

```dart
class Note {
  final String createdAt; // was int

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    createdAt: json['createdAt'] as String,
    // ...
  );
}

class UnresolvedQuestion {
  final String createdAt; // was int

  factory UnresolvedQuestion.fromJson(Map<String, dynamic> json) =>
      UnresolvedQuestion(
        createdAt: json['createdAt'] as String,
        // ...
      );
}
```

**When passing `updatedAt` back to the server** (e.g., for conflict detection on story update — see section 2.7), pass the raw string you received. Do not convert it to an integer first.

---

### 2.2 `AuthResponse.token` field renamed from `access_token`

**Priority: Critical — login will appear to succeed but every subsequent authenticated request will fail with 401.**

The auth response payload has always had a `data` wrapper. Inside that wrapper, the JWT field was previously `access_token`. It is now `token`.

**Response shape (both register and login):**
```json
{
  "success": true,
  "data": {
    "token": "<jwt>",
    "user": {
      "id": "uuid",
      "email": "user@example.com"
    }
  }
}
```

**Before:**
```dart
class AuthResponse {
  final String accessToken;
  final AuthUser user;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return AuthResponse(
      accessToken: data['access_token'] as String,
      user: AuthUser.fromJson(data['user'] as Map<String, dynamic>),
    );
  }
}
```

**After:**
```dart
class AuthResponse {
  final String token;
  final AuthUser user;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return AuthResponse(
      token: data['token'] as String,  // was 'access_token'
      user: AuthUser.fromJson(data['user'] as Map<String, dynamic>),
    );
  }
}
```

Also search your codebase for any place you read `data['access_token']` or `response.accessToken` directly from the parsed map — those will all return `null` silently if not updated.

---

### 2.3 JWT tokens expire in 15 minutes — handle 401 actively

**Priority: High — authenticated users will be silently kicked out mid-session.**

Previously tokens were long-lived. They now expire after 15 minutes. Any code path that stores a token and reuses it without checking for expiry will start receiving `401 Unauthorized` after the first 15 minutes.

There is no `/auth/refresh` endpoint yet. When a `401` is received, the only recovery path is re-authentication.

**Recommended pattern — HTTP interceptor:**

If you use `dio`:
```dart
class AuthInterceptor extends Interceptor {
  final AuthService _authService;
  final NavigatorKey _navigatorKey;

  AuthInterceptor(this._authService, this._navigatorKey);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token is expired or invalid — clear it and force re-login
      _authService.clearToken();
      _navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    }
    handler.next(err);
  }
}
```

If you use `http` directly:
```dart
Future<http.Response> authenticatedGet(String url) async {
  final response = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer ${_token}'},
  );
  if (response.statusCode == 401) {
    await _authService.clearToken();
    _router.go('/login');
    throw TokenExpiredException();
  }
  return response;
}
```

**Do not retry on 401.** A 401 from this API means the token is expired or invalid — retrying the same request will not help.

---

### 2.4 `Chapter.content` removed from list and get responses

**Priority: High — accessing `chapter.content` after a list/get call will return null; if your model declares it non-nullable, it will crash on parse.**

The `content` field is intentionally omitted from:
- `GET /stories/:storyId/chapters` (chapter list)
- `GET /chapters/:id` (single chapter metadata)

Use the new dedicated endpoints to read or write chapter content:
- `GET /chapters/:id/draft` → `{ "content": "..." }`
- `PUT /chapters/:id/draft` → body: `{ "content": "..." }`

**Before:**
```dart
class Chapter {
  final String id;
  final String storyId;
  final String title;
  final int order;
  final String status;
  final String content; // non-nullable — will crash if field is absent

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    content: json['content'] as String, // throws if content is null/absent
    // ...
  );
}
```

**After:**
```dart
class Chapter {
  final String id;
  final String storyId;
  final String title;
  final int order;
  final String status;
  final String? content; // nullable — not present in list/get responses

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    content: json['content'] as String?, // safe — returns null if absent
    // ...
  );
}
```

**Fetching chapter content when needed:**
```dart
Future<String> fetchChapterDraft(String chapterId) async {
  final response = await _client.get('/chapters/$chapterId/draft');
  final body = jsonDecode(response.body) as Map<String, dynamic>;
  return body['content'] as String;
}

Future<void> saveChapterDraft(String chapterId, String content) async {
  await _client.put(
    '/chapters/$chapterId/draft',
    body: jsonEncode({'content': content}),
  );
}
```

Do not eagerly fetch draft content in list screens — this is intentional to reduce payload size.

---

### 2.5 Rate limiting — handle 429 responses

**Priority: Medium — unhandled 429s may crash or freeze the app.**

Two tiers of rate limiting are now active:

| Scope | Limit |
|---|---|
| All endpoints | 60 requests per minute per IP |
| `/auth/login`, `/auth/register` | 10 requests per minute per IP |

When a limit is exceeded, the server responds with `429 Too Many Requests`.

**Add 429 handling alongside your 401 handling:**
```dart
if (response.statusCode == 429) {
  // Do not retry automatically — show a user-facing message
  throw RateLimitException(
    'Too many requests. Please wait a moment before trying again.',
  );
}
```

In your UI layer, catch `RateLimitException` and display it as a snackbar or dialog. Do not silently retry in a loop — that will only extend the rate-limited period.

For auth flows specifically, avoid triggering login or register on every keystroke or focus event. Confirm the user has intentionally submitted before calling the auth endpoints.

---

### 2.6 `TombstoneRecord` has a new `userId` field

**Priority: Medium — if you persist tombstones locally and round-trip them, you will get validation errors on push without this field.**

The `TombstoneRecord` model now includes `userId`. If you store tombstones in a local database or serialize them to shared preferences, your existing persisted records are missing this field.

**Updated model:**
```dart
class TombstoneRecord {
  final String id;
  final String userId;    // NEW — was absent before
  final String entityId;
  final String entityType;
  final String deletedAt; // ISO 8601 string

  factory TombstoneRecord.fromJson(Map<String, dynamic> json) =>
      TombstoneRecord(
        id: json['id'] as String,
        userId: json['userId'] as String,
        entityId: json['entityId'] as String,
        entityType: json['entityType'] as String,
        deletedAt: json['deletedAt'] as String,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'entityId': entityId,
    'entityType': entityType,
    'deletedAt': deletedAt,
  };
}
```

**Migration for locally persisted tombstones:** If you have tombstones stored without `userId`, you will need to backfill it from the current authenticated user's ID before the next sync push. A one-time migration on app startup is sufficient:

```dart
Future<void> backfillTombstoneUserIds(String currentUserId) async {
  final tombstones = await localDb.getAllTombstones();
  for (final t in tombstones) {
    if (t.userId.isEmpty) {
      await localDb.updateTombstone(t.copyWith(userId: currentUserId));
    }
  }
}
```

Tombstone pushes are now idempotent — pushing the same deletion twice is safe.

---

### 2.7 Password requirements tightened for registration

**Priority: Medium — register calls with passwords shorter than 12 characters will be rejected with 400.**

| Endpoint | Minimum password length | Maximum password length | Maximum email length |
|---|---|---|---|
| `POST /auth/register` | **12 characters** (was no minimum) | 128 characters | 254 characters |
| `POST /auth/login` | 8 characters | 128 characters | 254 characters |

Update your registration form validation to enforce the 12-character minimum client-side before submitting:

```dart
String? validatePassword(String? value, {bool isRegistration = false}) {
  if (value == null || value.isEmpty) return 'Password is required';
  final minLength = isRegistration ? 12 : 8;
  if (value.length < minLength) {
    return 'Password must be at least $minLength characters';
  }
  if (value.length > 128) {
    return 'Password must be 128 characters or fewer';
  }
  return null;
}
```

Enforcing this client-side prevents unnecessary round trips and gives users immediate feedback.

---

### 2.8 Sync push — 500-item limit per entity array

**Priority: Low for most clients, High if you batch large offline queues.**

Each entity array in a sync push payload is now limited to 500 items. Sending more than 500 in any single array returns `400 Bad Request`.

If you accumulate a large offline queue (e.g., after extended offline use), split pushes into chunks:

```dart
const int syncBatchSize = 500;

Future<void> pushInBatches<T>({
  required List<T> items,
  required Future<void> Function(List<T>) pushFn,
}) async {
  for (var i = 0; i < items.length; i += syncBatchSize) {
    final batch = items.sublist(
      i,
      (i + syncBatchSize).clamp(0, items.length),
    );
    await pushFn(batch);
  }
}
```

Apply this to each entity type (stories, characters, locations, events, chapters, notes, questions, relationships, tombstones) independently.

---

## 3. New Features to Adopt

### 3.1 `POST /ai/generic` — general-purpose AI prompt

A new AI endpoint accepts a free-form prompt and optional context string.

**Request:**
```json
{
  "prompt": "Suggest three names for a seafaring villain",
  "context": "The story is set in a steampunk 19th century world."
}
```

**Response:**
```json
{
  "text": "..."
}
```

**Dart usage:**
```dart
Future<String> callAiGeneric(String prompt, {String? context}) async {
  final body = <String, dynamic>{'prompt': prompt};
  if (context != null) body['context'] = context;

  final response = await _client.post(
    '/ai/generic',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    },
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['text'] as String;
  }
  throw ApiException(response.statusCode, response.body);
}
```

JWT is required. This endpoint is subject to the global 60 req/min rate limit.

### 3.2 Story update — optional conflict detection

`PUT /stories/:id` now supports optional conflict detection. If you include `updatedAt` in the request body and the server's record has a newer timestamp, the server returns `409 Conflict`.

This is opt-in. Omit `updatedAt` if you want last-write-wins behavior.

**Dart usage with conflict detection:**
```dart
Future<void> updateStory(Story story) async {
  final response = await _client.put(
    '/stories/${story.id}',
    body: jsonEncode({
      'title': story.title,
      'summary': story.summary,
      'updatedAt': story.updatedAt, // pass the ISO 8601 string as-is
    }),
  );

  if (response.statusCode == 409) {
    // Server has a newer version — fetch it and merge or prompt the user
    throw ConflictException('Story was updated remotely. Please refresh.');
  }
}
```

---

## 4. Migration Checklist

Use this list to track your progress. Each item maps to a section above.

### Critical (do these first)
- [ ] Update `Story.fromJson` — parse `createdAt` and `updatedAt` as `String`, not `int`
- [ ] Update `Note.fromJson` — parse `createdAt` as `String`, not `int`
- [ ] Update `UnresolvedQuestion.fromJson` — parse `createdAt` as `String`, not `int`
- [ ] Update `AuthResponse.fromJson` — read `data['token']`, not `data['access_token']`
- [ ] Search codebase for all usages of `access_token` in auth response parsing and replace with `token`
- [ ] Update `Chapter` model — make `content` field nullable (`String?`)
- [ ] Update `Chapter.fromJson` — use `json['content'] as String?` (safe null)

### High priority
- [ ] Add 401 handler in HTTP interceptor — clear token and navigate to login
- [ ] Replace direct `chapter.content` accesses in UI with calls to `GET /chapters/:id/draft`
- [ ] Add `PUT /chapters/:id/draft` for saving chapter content
- [ ] Remove any usage of `chapter.content` from list screen rendering

### Medium priority
- [ ] Add 429 handler in HTTP interceptor — show user-facing message, do not auto-retry
- [ ] Update `TombstoneRecord` model to include `userId` field
- [ ] Add local tombstone migration to backfill `userId` on app startup
- [ ] Update registration form validator — minimum password length is now 12 characters
- [ ] Verify `DateTime` display helpers use `DateTime.parse(isoString)` not `DateTime.fromMillisecondsSinceEpoch(int)`

### Low priority / enhancements
- [ ] Add sync push batching — split arrays larger than 500 items across multiple calls
- [ ] Implement `POST /ai/generic` if you need free-form AI prompts
- [ ] Consider implementing story conflict detection using `updatedAt` in `PUT /stories/:id`

---

## 5. Testing Tips

### Verify timestamp parsing
Add a unit test for each affected `fromJson` factory using a fixture with a real ISO 8601 string:

```dart
test('Story.fromJson parses ISO 8601 timestamps', () {
  final json = {
    'id': 'abc123',
    'userId': 'user1',
    'title': 'Test Story',
    'summary': 'A summary',
    'createdAt': '2026-03-10T14:30:00.000Z',
    'updatedAt': '2026-03-10T15:00:00.000Z',
  };
  final story = Story.fromJson(json);
  expect(story.createdAt, equals('2026-03-10T14:30:00.000Z'));
  expect(story.createdAtDate.year, equals(2026));
  expect(story.updatedAtDate.isAfter(story.createdAtDate), isTrue);
});
```

### Verify auth token field
```dart
test('AuthResponse reads token field not access_token', () {
  final json = {
    'success': true,
    'data': {
      'token': 'eyJhbGciOi...',
      'user': {'id': 'u1', 'email': 'test@example.com'},
    },
  };
  final auth = AuthResponse.fromJson(json);
  expect(auth.token, equals('eyJhbGciOi...'));
});
```

### Verify 401 handling in integration tests
Using a mock HTTP client, simulate a 401 response and assert that:
1. The stored token is cleared.
2. The navigation stack is replaced with the login screen.
3. No retry is attempted.

### Verify chapter content nullability
```dart
test('Chapter.fromJson handles missing content field', () {
  final json = {
    'id': 'ch1',
    'storyId': 's1',
    'userId': 'u1',
    'title': 'Chapter 1',
    'order': 1,
    'status': 'draft',
    // 'content' intentionally absent
  };
  final chapter = Chapter.fromJson(json);
  expect(chapter.content, isNull); // must not throw
});
```

### End-to-end smoke test sequence
Run through this sequence against a real or staging backend after applying changes:

1. Register with a 12+ character password — expect `200` with `data.token` present.
2. Login with the same credentials — expect `200` with `data.token` present.
3. Wait 16 minutes (or use a short-lived test token), then make an authenticated request — expect `401` and verify the app navigates to login.
4. Create a story, then fetch it — verify `createdAt` is a parseable ISO 8601 string.
5. Fetch the chapter list for that story — verify `content` is null/absent, then call `GET /chapters/:id/draft` and verify `content` is returned.
6. Trigger 11 login attempts in under a minute — verify the 11th returns `429` and the app shows an error message rather than crashing.

### Check for silent `null` bugs
After updating `fromJson` factories, run the app in debug mode with `assert`s enabled. If a field silently returns `null` where it was previously typed as non-null, the assert will surface it immediately rather than causing a downstream crash.

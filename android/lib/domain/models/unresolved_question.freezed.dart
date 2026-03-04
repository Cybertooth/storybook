// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unresolved_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnresolvedQuestion {
  String get id;
  String get storyId;
  String get question;
  String get details;
  bool get isResolved;
  String? get answer;
  DateTime get createdAt;

  /// Create a copy of UnresolvedQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnresolvedQuestionCopyWith<UnresolvedQuestion> get copyWith =>
      _$UnresolvedQuestionCopyWithImpl<UnresolvedQuestion>(
          this as UnresolvedQuestion, _$identity);

  /// Serializes this UnresolvedQuestion to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnresolvedQuestion &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storyId, storyId) || other.storyId == storyId) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.details, details) || other.details == details) &&
            (identical(other.isResolved, isResolved) ||
                other.isResolved == isResolved) &&
            (identical(other.answer, answer) || other.answer == answer) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, storyId, question, details,
      isResolved, answer, createdAt);

  @override
  String toString() {
    return 'UnresolvedQuestion(id: $id, storyId: $storyId, question: $question, details: $details, isResolved: $isResolved, answer: $answer, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $UnresolvedQuestionCopyWith<$Res> {
  factory $UnresolvedQuestionCopyWith(
          UnresolvedQuestion value, $Res Function(UnresolvedQuestion) _then) =
      _$UnresolvedQuestionCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String storyId,
      String question,
      String details,
      bool isResolved,
      String? answer,
      DateTime createdAt});
}

/// @nodoc
class _$UnresolvedQuestionCopyWithImpl<$Res>
    implements $UnresolvedQuestionCopyWith<$Res> {
  _$UnresolvedQuestionCopyWithImpl(this._self, this._then);

  final UnresolvedQuestion _self;
  final $Res Function(UnresolvedQuestion) _then;

  /// Create a copy of UnresolvedQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storyId = null,
    Object? question = null,
    Object? details = null,
    Object? isResolved = null,
    Object? answer = freezed,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storyId: null == storyId
          ? _self.storyId
          : storyId // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _self.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      details: null == details
          ? _self.details
          : details // ignore: cast_nullable_to_non_nullable
              as String,
      isResolved: null == isResolved
          ? _self.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      answer: freezed == answer
          ? _self.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [UnresolvedQuestion].
extension UnresolvedQuestionPatterns on UnresolvedQuestion {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UnresolvedQuestion value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UnresolvedQuestion() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UnresolvedQuestion value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UnresolvedQuestion():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UnresolvedQuestion value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UnresolvedQuestion() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String storyId, String question, String details,
            bool isResolved, String? answer, DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UnresolvedQuestion() when $default != null:
        return $default(_that.id, _that.storyId, _that.question, _that.details,
            _that.isResolved, _that.answer, _that.createdAt);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String storyId, String question, String details,
            bool isResolved, String? answer, DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UnresolvedQuestion():
        return $default(_that.id, _that.storyId, _that.question, _that.details,
            _that.isResolved, _that.answer, _that.createdAt);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String storyId,
            String question,
            String details,
            bool isResolved,
            String? answer,
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UnresolvedQuestion() when $default != null:
        return $default(_that.id, _that.storyId, _that.question, _that.details,
            _that.isResolved, _that.answer, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UnresolvedQuestion implements UnresolvedQuestion {
  const _UnresolvedQuestion(
      {required this.id,
      required this.storyId,
      required this.question,
      this.details = '',
      this.isResolved = false,
      this.answer,
      required this.createdAt});
  factory _UnresolvedQuestion.fromJson(Map<String, dynamic> json) =>
      _$UnresolvedQuestionFromJson(json);

  @override
  final String id;
  @override
  final String storyId;
  @override
  final String question;
  @override
  @JsonKey()
  final String details;
  @override
  @JsonKey()
  final bool isResolved;
  @override
  final String? answer;
  @override
  final DateTime createdAt;

  /// Create a copy of UnresolvedQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UnresolvedQuestionCopyWith<_UnresolvedQuestion> get copyWith =>
      __$UnresolvedQuestionCopyWithImpl<_UnresolvedQuestion>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UnresolvedQuestionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UnresolvedQuestion &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storyId, storyId) || other.storyId == storyId) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.details, details) || other.details == details) &&
            (identical(other.isResolved, isResolved) ||
                other.isResolved == isResolved) &&
            (identical(other.answer, answer) || other.answer == answer) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, storyId, question, details,
      isResolved, answer, createdAt);

  @override
  String toString() {
    return 'UnresolvedQuestion(id: $id, storyId: $storyId, question: $question, details: $details, isResolved: $isResolved, answer: $answer, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$UnresolvedQuestionCopyWith<$Res>
    implements $UnresolvedQuestionCopyWith<$Res> {
  factory _$UnresolvedQuestionCopyWith(
          _UnresolvedQuestion value, $Res Function(_UnresolvedQuestion) _then) =
      __$UnresolvedQuestionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String storyId,
      String question,
      String details,
      bool isResolved,
      String? answer,
      DateTime createdAt});
}

/// @nodoc
class __$UnresolvedQuestionCopyWithImpl<$Res>
    implements _$UnresolvedQuestionCopyWith<$Res> {
  __$UnresolvedQuestionCopyWithImpl(this._self, this._then);

  final _UnresolvedQuestion _self;
  final $Res Function(_UnresolvedQuestion) _then;

  /// Create a copy of UnresolvedQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? storyId = null,
    Object? question = null,
    Object? details = null,
    Object? isResolved = null,
    Object? answer = freezed,
    Object? createdAt = null,
  }) {
    return _then(_UnresolvedQuestion(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storyId: null == storyId
          ? _self.storyId
          : storyId // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _self.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      details: null == details
          ? _self.details
          : details // ignore: cast_nullable_to_non_nullable
              as String,
      isResolved: null == isResolved
          ? _self.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      answer: freezed == answer
          ? _self.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Character {
  String get id;
  String get storyId;
  String get name;
  CharacterRole get role;
  String get description;
  List<String> get traits;
  String? get arcLie;
  String? get arcTruth;
  String? get arcGhost;
  String? get avatarUrl;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CharacterCopyWith<Character> get copyWith =>
      _$CharacterCopyWithImpl<Character>(this as Character, _$identity);

  /// Serializes this Character to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Character &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storyId, storyId) || other.storyId == storyId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other.traits, traits) &&
            (identical(other.arcLie, arcLie) || other.arcLie == arcLie) &&
            (identical(other.arcTruth, arcTruth) ||
                other.arcTruth == arcTruth) &&
            (identical(other.arcGhost, arcGhost) ||
                other.arcGhost == arcGhost) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      storyId,
      name,
      role,
      description,
      const DeepCollectionEquality().hash(traits),
      arcLie,
      arcTruth,
      arcGhost,
      avatarUrl);

  @override
  String toString() {
    return 'Character(id: $id, storyId: $storyId, name: $name, role: $role, description: $description, traits: $traits, arcLie: $arcLie, arcTruth: $arcTruth, arcGhost: $arcGhost, avatarUrl: $avatarUrl)';
  }
}

/// @nodoc
abstract mixin class $CharacterCopyWith<$Res> {
  factory $CharacterCopyWith(Character value, $Res Function(Character) _then) =
      _$CharacterCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String storyId,
      String name,
      CharacterRole role,
      String description,
      List<String> traits,
      String? arcLie,
      String? arcTruth,
      String? arcGhost,
      String? avatarUrl});
}

/// @nodoc
class _$CharacterCopyWithImpl<$Res> implements $CharacterCopyWith<$Res> {
  _$CharacterCopyWithImpl(this._self, this._then);

  final Character _self;
  final $Res Function(Character) _then;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storyId = null,
    Object? name = null,
    Object? role = null,
    Object? description = null,
    Object? traits = null,
    Object? arcLie = freezed,
    Object? arcTruth = freezed,
    Object? arcGhost = freezed,
    Object? avatarUrl = freezed,
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
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as CharacterRole,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      traits: null == traits
          ? _self.traits
          : traits // ignore: cast_nullable_to_non_nullable
              as List<String>,
      arcLie: freezed == arcLie
          ? _self.arcLie
          : arcLie // ignore: cast_nullable_to_non_nullable
              as String?,
      arcTruth: freezed == arcTruth
          ? _self.arcTruth
          : arcTruth // ignore: cast_nullable_to_non_nullable
              as String?,
      arcGhost: freezed == arcGhost
          ? _self.arcGhost
          : arcGhost // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Character].
extension CharacterPatterns on Character {
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
    TResult Function(_Character value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Character() when $default != null:
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
    TResult Function(_Character value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Character():
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
    TResult? Function(_Character value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Character() when $default != null:
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
    TResult Function(
            String id,
            String storyId,
            String name,
            CharacterRole role,
            String description,
            List<String> traits,
            String? arcLie,
            String? arcTruth,
            String? arcGhost,
            String? avatarUrl)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Character() when $default != null:
        return $default(
            _that.id,
            _that.storyId,
            _that.name,
            _that.role,
            _that.description,
            _that.traits,
            _that.arcLie,
            _that.arcTruth,
            _that.arcGhost,
            _that.avatarUrl);
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
    TResult Function(
            String id,
            String storyId,
            String name,
            CharacterRole role,
            String description,
            List<String> traits,
            String? arcLie,
            String? arcTruth,
            String? arcGhost,
            String? avatarUrl)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Character():
        return $default(
            _that.id,
            _that.storyId,
            _that.name,
            _that.role,
            _that.description,
            _that.traits,
            _that.arcLie,
            _that.arcTruth,
            _that.arcGhost,
            _that.avatarUrl);
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
            String name,
            CharacterRole role,
            String description,
            List<String> traits,
            String? arcLie,
            String? arcTruth,
            String? arcGhost,
            String? avatarUrl)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Character() when $default != null:
        return $default(
            _that.id,
            _that.storyId,
            _that.name,
            _that.role,
            _that.description,
            _that.traits,
            _that.arcLie,
            _that.arcTruth,
            _that.arcGhost,
            _that.avatarUrl);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Character implements Character {
  const _Character(
      {required this.id,
      required this.storyId,
      required this.name,
      this.role = CharacterRole.supporting,
      this.description = '',
      final List<String> traits = const [],
      this.arcLie,
      this.arcTruth,
      this.arcGhost,
      this.avatarUrl})
      : _traits = traits;
  factory _Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);

  @override
  final String id;
  @override
  final String storyId;
  @override
  final String name;
  @override
  @JsonKey()
  final CharacterRole role;
  @override
  @JsonKey()
  final String description;
  final List<String> _traits;
  @override
  @JsonKey()
  List<String> get traits {
    if (_traits is EqualUnmodifiableListView) return _traits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_traits);
  }

  @override
  final String? arcLie;
  @override
  final String? arcTruth;
  @override
  final String? arcGhost;
  @override
  final String? avatarUrl;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CharacterCopyWith<_Character> get copyWith =>
      __$CharacterCopyWithImpl<_Character>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CharacterToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Character &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storyId, storyId) || other.storyId == storyId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._traits, _traits) &&
            (identical(other.arcLie, arcLie) || other.arcLie == arcLie) &&
            (identical(other.arcTruth, arcTruth) ||
                other.arcTruth == arcTruth) &&
            (identical(other.arcGhost, arcGhost) ||
                other.arcGhost == arcGhost) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      storyId,
      name,
      role,
      description,
      const DeepCollectionEquality().hash(_traits),
      arcLie,
      arcTruth,
      arcGhost,
      avatarUrl);

  @override
  String toString() {
    return 'Character(id: $id, storyId: $storyId, name: $name, role: $role, description: $description, traits: $traits, arcLie: $arcLie, arcTruth: $arcTruth, arcGhost: $arcGhost, avatarUrl: $avatarUrl)';
  }
}

/// @nodoc
abstract mixin class _$CharacterCopyWith<$Res>
    implements $CharacterCopyWith<$Res> {
  factory _$CharacterCopyWith(
          _Character value, $Res Function(_Character) _then) =
      __$CharacterCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String storyId,
      String name,
      CharacterRole role,
      String description,
      List<String> traits,
      String? arcLie,
      String? arcTruth,
      String? arcGhost,
      String? avatarUrl});
}

/// @nodoc
class __$CharacterCopyWithImpl<$Res> implements _$CharacterCopyWith<$Res> {
  __$CharacterCopyWithImpl(this._self, this._then);

  final _Character _self;
  final $Res Function(_Character) _then;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? storyId = null,
    Object? name = null,
    Object? role = null,
    Object? description = null,
    Object? traits = null,
    Object? arcLie = freezed,
    Object? arcTruth = freezed,
    Object? arcGhost = freezed,
    Object? avatarUrl = freezed,
  }) {
    return _then(_Character(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storyId: null == storyId
          ? _self.storyId
          : storyId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as CharacterRole,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      traits: null == traits
          ? _self._traits
          : traits // ignore: cast_nullable_to_non_nullable
              as List<String>,
      arcLie: freezed == arcLie
          ? _self.arcLie
          : arcLie // ignore: cast_nullable_to_non_nullable
              as String?,
      arcTruth: freezed == arcTruth
          ? _self.arcTruth
          : arcTruth // ignore: cast_nullable_to_non_nullable
              as String?,
      arcGhost: freezed == arcGhost
          ? _self.arcGhost
          : arcGhost // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on

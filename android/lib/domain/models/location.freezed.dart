// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Location {
  String get id;
  String get storyId;
  String get name;
  String get description;
  String? get sensorySight;
  String? get sensorySound;
  String? get sensorySmell;
  String? get sensoryTouch;
  String? get sensoryTaste;

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LocationCopyWith<Location> get copyWith =>
      _$LocationCopyWithImpl<Location>(this as Location, _$identity);

  /// Serializes this Location to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Location &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storyId, storyId) || other.storyId == storyId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sensorySight, sensorySight) ||
                other.sensorySight == sensorySight) &&
            (identical(other.sensorySound, sensorySound) ||
                other.sensorySound == sensorySound) &&
            (identical(other.sensorySmell, sensorySmell) ||
                other.sensorySmell == sensorySmell) &&
            (identical(other.sensoryTouch, sensoryTouch) ||
                other.sensoryTouch == sensoryTouch) &&
            (identical(other.sensoryTaste, sensoryTaste) ||
                other.sensoryTaste == sensoryTaste));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, storyId, name, description,
      sensorySight, sensorySound, sensorySmell, sensoryTouch, sensoryTaste);

  @override
  String toString() {
    return 'Location(id: $id, storyId: $storyId, name: $name, description: $description, sensorySight: $sensorySight, sensorySound: $sensorySound, sensorySmell: $sensorySmell, sensoryTouch: $sensoryTouch, sensoryTaste: $sensoryTaste)';
  }
}

/// @nodoc
abstract mixin class $LocationCopyWith<$Res> {
  factory $LocationCopyWith(Location value, $Res Function(Location) _then) =
      _$LocationCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String storyId,
      String name,
      String description,
      String? sensorySight,
      String? sensorySound,
      String? sensorySmell,
      String? sensoryTouch,
      String? sensoryTaste});
}

/// @nodoc
class _$LocationCopyWithImpl<$Res> implements $LocationCopyWith<$Res> {
  _$LocationCopyWithImpl(this._self, this._then);

  final Location _self;
  final $Res Function(Location) _then;

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storyId = null,
    Object? name = null,
    Object? description = null,
    Object? sensorySight = freezed,
    Object? sensorySound = freezed,
    Object? sensorySmell = freezed,
    Object? sensoryTouch = freezed,
    Object? sensoryTaste = freezed,
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
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      sensorySight: freezed == sensorySight
          ? _self.sensorySight
          : sensorySight // ignore: cast_nullable_to_non_nullable
              as String?,
      sensorySound: freezed == sensorySound
          ? _self.sensorySound
          : sensorySound // ignore: cast_nullable_to_non_nullable
              as String?,
      sensorySmell: freezed == sensorySmell
          ? _self.sensorySmell
          : sensorySmell // ignore: cast_nullable_to_non_nullable
              as String?,
      sensoryTouch: freezed == sensoryTouch
          ? _self.sensoryTouch
          : sensoryTouch // ignore: cast_nullable_to_non_nullable
              as String?,
      sensoryTaste: freezed == sensoryTaste
          ? _self.sensoryTaste
          : sensoryTaste // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Location].
extension LocationPatterns on Location {
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
    TResult Function(_Location value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Location() when $default != null:
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
    TResult Function(_Location value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Location():
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
    TResult? Function(_Location value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Location() when $default != null:
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
            String description,
            String? sensorySight,
            String? sensorySound,
            String? sensorySmell,
            String? sensoryTouch,
            String? sensoryTaste)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Location() when $default != null:
        return $default(
            _that.id,
            _that.storyId,
            _that.name,
            _that.description,
            _that.sensorySight,
            _that.sensorySound,
            _that.sensorySmell,
            _that.sensoryTouch,
            _that.sensoryTaste);
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
            String description,
            String? sensorySight,
            String? sensorySound,
            String? sensorySmell,
            String? sensoryTouch,
            String? sensoryTaste)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Location():
        return $default(
            _that.id,
            _that.storyId,
            _that.name,
            _that.description,
            _that.sensorySight,
            _that.sensorySound,
            _that.sensorySmell,
            _that.sensoryTouch,
            _that.sensoryTaste);
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
            String description,
            String? sensorySight,
            String? sensorySound,
            String? sensorySmell,
            String? sensoryTouch,
            String? sensoryTaste)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Location() when $default != null:
        return $default(
            _that.id,
            _that.storyId,
            _that.name,
            _that.description,
            _that.sensorySight,
            _that.sensorySound,
            _that.sensorySmell,
            _that.sensoryTouch,
            _that.sensoryTaste);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Location implements Location {
  const _Location(
      {required this.id,
      required this.storyId,
      required this.name,
      this.description = '',
      this.sensorySight,
      this.sensorySound,
      this.sensorySmell,
      this.sensoryTouch,
      this.sensoryTaste});
  factory _Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  @override
  final String id;
  @override
  final String storyId;
  @override
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  final String? sensorySight;
  @override
  final String? sensorySound;
  @override
  final String? sensorySmell;
  @override
  final String? sensoryTouch;
  @override
  final String? sensoryTaste;

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LocationCopyWith<_Location> get copyWith =>
      __$LocationCopyWithImpl<_Location>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LocationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Location &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storyId, storyId) || other.storyId == storyId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sensorySight, sensorySight) ||
                other.sensorySight == sensorySight) &&
            (identical(other.sensorySound, sensorySound) ||
                other.sensorySound == sensorySound) &&
            (identical(other.sensorySmell, sensorySmell) ||
                other.sensorySmell == sensorySmell) &&
            (identical(other.sensoryTouch, sensoryTouch) ||
                other.sensoryTouch == sensoryTouch) &&
            (identical(other.sensoryTaste, sensoryTaste) ||
                other.sensoryTaste == sensoryTaste));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, storyId, name, description,
      sensorySight, sensorySound, sensorySmell, sensoryTouch, sensoryTaste);

  @override
  String toString() {
    return 'Location(id: $id, storyId: $storyId, name: $name, description: $description, sensorySight: $sensorySight, sensorySound: $sensorySound, sensorySmell: $sensorySmell, sensoryTouch: $sensoryTouch, sensoryTaste: $sensoryTaste)';
  }
}

/// @nodoc
abstract mixin class _$LocationCopyWith<$Res>
    implements $LocationCopyWith<$Res> {
  factory _$LocationCopyWith(_Location value, $Res Function(_Location) _then) =
      __$LocationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String storyId,
      String name,
      String description,
      String? sensorySight,
      String? sensorySound,
      String? sensorySmell,
      String? sensoryTouch,
      String? sensoryTaste});
}

/// @nodoc
class __$LocationCopyWithImpl<$Res> implements _$LocationCopyWith<$Res> {
  __$LocationCopyWithImpl(this._self, this._then);

  final _Location _self;
  final $Res Function(_Location) _then;

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? storyId = null,
    Object? name = null,
    Object? description = null,
    Object? sensorySight = freezed,
    Object? sensorySound = freezed,
    Object? sensorySmell = freezed,
    Object? sensoryTouch = freezed,
    Object? sensoryTaste = freezed,
  }) {
    return _then(_Location(
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
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      sensorySight: freezed == sensorySight
          ? _self.sensorySight
          : sensorySight // ignore: cast_nullable_to_non_nullable
              as String?,
      sensorySound: freezed == sensorySound
          ? _self.sensorySound
          : sensorySound // ignore: cast_nullable_to_non_nullable
              as String?,
      sensorySmell: freezed == sensorySmell
          ? _self.sensorySmell
          : sensorySmell // ignore: cast_nullable_to_non_nullable
              as String?,
      sensoryTouch: freezed == sensoryTouch
          ? _self.sensoryTouch
          : sensoryTouch // ignore: cast_nullable_to_non_nullable
              as String?,
      sensoryTaste: freezed == sensoryTaste
          ? _self.sensoryTaste
          : sensoryTaste // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on

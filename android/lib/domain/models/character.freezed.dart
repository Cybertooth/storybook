// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Character _$CharacterFromJson(Map<String, dynamic> json) {
  return _Character.fromJson(json);
}

/// @nodoc
mixin _$Character {
  String get id => throw _privateConstructorUsedError;
  String get storyId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  CharacterRole get role => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get traits => throw _privateConstructorUsedError;
  String? get arcLie => throw _privateConstructorUsedError;
  String? get arcTruth => throw _privateConstructorUsedError;
  String? get arcGhost => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;

  /// Serializes this Character to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CharacterCopyWith<Character> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CharacterCopyWith<$Res> {
  factory $CharacterCopyWith(Character value, $Res Function(Character) then) =
      _$CharacterCopyWithImpl<$Res, Character>;
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
class _$CharacterCopyWithImpl<$Res, $Val extends Character>
    implements $CharacterCopyWith<$Res> {
  _$CharacterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storyId: null == storyId
          ? _value.storyId
          : storyId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as CharacterRole,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      traits: null == traits
          ? _value.traits
          : traits // ignore: cast_nullable_to_non_nullable
              as List<String>,
      arcLie: freezed == arcLie
          ? _value.arcLie
          : arcLie // ignore: cast_nullable_to_non_nullable
              as String?,
      arcTruth: freezed == arcTruth
          ? _value.arcTruth
          : arcTruth // ignore: cast_nullable_to_non_nullable
              as String?,
      arcGhost: freezed == arcGhost
          ? _value.arcGhost
          : arcGhost // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CharacterImplCopyWith<$Res>
    implements $CharacterCopyWith<$Res> {
  factory _$$CharacterImplCopyWith(
          _$CharacterImpl value, $Res Function(_$CharacterImpl) then) =
      __$$CharacterImplCopyWithImpl<$Res>;
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
class __$$CharacterImplCopyWithImpl<$Res>
    extends _$CharacterCopyWithImpl<$Res, _$CharacterImpl>
    implements _$$CharacterImplCopyWith<$Res> {
  __$$CharacterImplCopyWithImpl(
      _$CharacterImpl _value, $Res Function(_$CharacterImpl) _then)
      : super(_value, _then);

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
    return _then(_$CharacterImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storyId: null == storyId
          ? _value.storyId
          : storyId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as CharacterRole,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      traits: null == traits
          ? _value._traits
          : traits // ignore: cast_nullable_to_non_nullable
              as List<String>,
      arcLie: freezed == arcLie
          ? _value.arcLie
          : arcLie // ignore: cast_nullable_to_non_nullable
              as String?,
      arcTruth: freezed == arcTruth
          ? _value.arcTruth
          : arcTruth // ignore: cast_nullable_to_non_nullable
              as String?,
      arcGhost: freezed == arcGhost
          ? _value.arcGhost
          : arcGhost // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CharacterImpl implements _Character {
  const _$CharacterImpl(
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

  factory _$CharacterImpl.fromJson(Map<String, dynamic> json) =>
      _$$CharacterImplFromJson(json);

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

  @override
  String toString() {
    return 'Character(id: $id, storyId: $storyId, name: $name, role: $role, description: $description, traits: $traits, arcLie: $arcLie, arcTruth: $arcTruth, arcGhost: $arcGhost, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterImpl &&
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

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterImplCopyWith<_$CharacterImpl> get copyWith =>
      __$$CharacterImplCopyWithImpl<_$CharacterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CharacterImplToJson(
      this,
    );
  }
}

abstract class _Character implements Character {
  const factory _Character(
      {required final String id,
      required final String storyId,
      required final String name,
      final CharacterRole role,
      final String description,
      final List<String> traits,
      final String? arcLie,
      final String? arcTruth,
      final String? arcGhost,
      final String? avatarUrl}) = _$CharacterImpl;

  factory _Character.fromJson(Map<String, dynamic> json) =
      _$CharacterImpl.fromJson;

  @override
  String get id;
  @override
  String get storyId;
  @override
  String get name;
  @override
  CharacterRole get role;
  @override
  String get description;
  @override
  List<String> get traits;
  @override
  String? get arcLie;
  @override
  String? get arcTruth;
  @override
  String? get arcGhost;
  @override
  String? get avatarUrl;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterImplCopyWith<_$CharacterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

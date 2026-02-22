// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unresolved_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UnresolvedQuestion _$UnresolvedQuestionFromJson(Map<String, dynamic> json) {
  return _UnresolvedQuestion.fromJson(json);
}

/// @nodoc
mixin _$UnresolvedQuestion {
  String get id => throw _privateConstructorUsedError;
  String get storyId => throw _privateConstructorUsedError;
  String get question => throw _privateConstructorUsedError;
  String get details => throw _privateConstructorUsedError;
  bool get isResolved => throw _privateConstructorUsedError;
  String? get answer => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this UnresolvedQuestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UnresolvedQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UnresolvedQuestionCopyWith<UnresolvedQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnresolvedQuestionCopyWith<$Res> {
  factory $UnresolvedQuestionCopyWith(
          UnresolvedQuestion value, $Res Function(UnresolvedQuestion) then) =
      _$UnresolvedQuestionCopyWithImpl<$Res, UnresolvedQuestion>;
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
class _$UnresolvedQuestionCopyWithImpl<$Res, $Val extends UnresolvedQuestion>
    implements $UnresolvedQuestionCopyWith<$Res> {
  _$UnresolvedQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storyId: null == storyId
          ? _value.storyId
          : storyId // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String,
      isResolved: null == isResolved
          ? _value.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      answer: freezed == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UnresolvedQuestionImplCopyWith<$Res>
    implements $UnresolvedQuestionCopyWith<$Res> {
  factory _$$UnresolvedQuestionImplCopyWith(_$UnresolvedQuestionImpl value,
          $Res Function(_$UnresolvedQuestionImpl) then) =
      __$$UnresolvedQuestionImplCopyWithImpl<$Res>;
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
class __$$UnresolvedQuestionImplCopyWithImpl<$Res>
    extends _$UnresolvedQuestionCopyWithImpl<$Res, _$UnresolvedQuestionImpl>
    implements _$$UnresolvedQuestionImplCopyWith<$Res> {
  __$$UnresolvedQuestionImplCopyWithImpl(_$UnresolvedQuestionImpl _value,
      $Res Function(_$UnresolvedQuestionImpl) _then)
      : super(_value, _then);

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
    return _then(_$UnresolvedQuestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storyId: null == storyId
          ? _value.storyId
          : storyId // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String,
      isResolved: null == isResolved
          ? _value.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      answer: freezed == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UnresolvedQuestionImpl implements _UnresolvedQuestion {
  const _$UnresolvedQuestionImpl(
      {required this.id,
      required this.storyId,
      required this.question,
      this.details = '',
      this.isResolved = false,
      this.answer,
      required this.createdAt});

  factory _$UnresolvedQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnresolvedQuestionImplFromJson(json);

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

  @override
  String toString() {
    return 'UnresolvedQuestion(id: $id, storyId: $storyId, question: $question, details: $details, isResolved: $isResolved, answer: $answer, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnresolvedQuestionImpl &&
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

  /// Create a copy of UnresolvedQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnresolvedQuestionImplCopyWith<_$UnresolvedQuestionImpl> get copyWith =>
      __$$UnresolvedQuestionImplCopyWithImpl<_$UnresolvedQuestionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnresolvedQuestionImplToJson(
      this,
    );
  }
}

abstract class _UnresolvedQuestion implements UnresolvedQuestion {
  const factory _UnresolvedQuestion(
      {required final String id,
      required final String storyId,
      required final String question,
      final String details,
      final bool isResolved,
      final String? answer,
      required final DateTime createdAt}) = _$UnresolvedQuestionImpl;

  factory _UnresolvedQuestion.fromJson(Map<String, dynamic> json) =
      _$UnresolvedQuestionImpl.fromJson;

  @override
  String get id;
  @override
  String get storyId;
  @override
  String get question;
  @override
  String get details;
  @override
  bool get isResolved;
  @override
  String? get answer;
  @override
  DateTime get createdAt;

  /// Create a copy of UnresolvedQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnresolvedQuestionImplCopyWith<_$UnresolvedQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plot_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlotEvent {
  String get id;
  String get storyId;
  String get title;
  String get description;
  int get order;
  String? get chapterId;
  List<String> get characterIds;
  String? get locationId;
  EventStatus get status;
  String get plotThread;
  int get emotionalValue;

  /// Create a copy of PlotEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlotEventCopyWith<PlotEvent> get copyWith =>
      _$PlotEventCopyWithImpl<PlotEvent>(this as PlotEvent, _$identity);

  /// Serializes this PlotEvent to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlotEvent &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storyId, storyId) || other.storyId == storyId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            const DeepCollectionEquality()
                .equals(other.characterIds, characterIds) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.plotThread, plotThread) ||
                other.plotThread == plotThread) &&
            (identical(other.emotionalValue, emotionalValue) ||
                other.emotionalValue == emotionalValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      storyId,
      title,
      description,
      order,
      chapterId,
      const DeepCollectionEquality().hash(characterIds),
      locationId,
      status,
      plotThread,
      emotionalValue);

  @override
  String toString() {
    return 'PlotEvent(id: $id, storyId: $storyId, title: $title, description: $description, order: $order, chapterId: $chapterId, characterIds: $characterIds, locationId: $locationId, status: $status, plotThread: $plotThread, emotionalValue: $emotionalValue)';
  }
}

/// @nodoc
abstract mixin class $PlotEventCopyWith<$Res> {
  factory $PlotEventCopyWith(PlotEvent value, $Res Function(PlotEvent) _then) =
      _$PlotEventCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String storyId,
      String title,
      String description,
      int order,
      String? chapterId,
      List<String> characterIds,
      String? locationId,
      EventStatus status,
      String plotThread,
      int emotionalValue});
}

/// @nodoc
class _$PlotEventCopyWithImpl<$Res> implements $PlotEventCopyWith<$Res> {
  _$PlotEventCopyWithImpl(this._self, this._then);

  final PlotEvent _self;
  final $Res Function(PlotEvent) _then;

  /// Create a copy of PlotEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storyId = null,
    Object? title = null,
    Object? description = null,
    Object? order = null,
    Object? chapterId = freezed,
    Object? characterIds = null,
    Object? locationId = freezed,
    Object? status = null,
    Object? plotThread = null,
    Object? emotionalValue = null,
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
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      chapterId: freezed == chapterId
          ? _self.chapterId
          : chapterId // ignore: cast_nullable_to_non_nullable
              as String?,
      characterIds: null == characterIds
          ? _self.characterIds
          : characterIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      locationId: freezed == locationId
          ? _self.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatus,
      plotThread: null == plotThread
          ? _self.plotThread
          : plotThread // ignore: cast_nullable_to_non_nullable
              as String,
      emotionalValue: null == emotionalValue
          ? _self.emotionalValue
          : emotionalValue // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [PlotEvent].
extension PlotEventPatterns on PlotEvent {
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
    TResult Function(_PlotEvent value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlotEvent() when $default != null:
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
    TResult Function(_PlotEvent value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlotEvent():
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
    TResult? Function(_PlotEvent value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlotEvent() when $default != null:
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
            String title,
            String description,
            int order,
            String? chapterId,
            List<String> characterIds,
            String? locationId,
            EventStatus status,
            String plotThread,
            int emotionalValue)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlotEvent() when $default != null:
        return $default(
            _that.id,
            _that.storyId,
            _that.title,
            _that.description,
            _that.order,
            _that.chapterId,
            _that.characterIds,
            _that.locationId,
            _that.status,
            _that.plotThread,
            _that.emotionalValue);
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
            String title,
            String description,
            int order,
            String? chapterId,
            List<String> characterIds,
            String? locationId,
            EventStatus status,
            String plotThread,
            int emotionalValue)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlotEvent():
        return $default(
            _that.id,
            _that.storyId,
            _that.title,
            _that.description,
            _that.order,
            _that.chapterId,
            _that.characterIds,
            _that.locationId,
            _that.status,
            _that.plotThread,
            _that.emotionalValue);
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
            String title,
            String description,
            int order,
            String? chapterId,
            List<String> characterIds,
            String? locationId,
            EventStatus status,
            String plotThread,
            int emotionalValue)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlotEvent() when $default != null:
        return $default(
            _that.id,
            _that.storyId,
            _that.title,
            _that.description,
            _that.order,
            _that.chapterId,
            _that.characterIds,
            _that.locationId,
            _that.status,
            _that.plotThread,
            _that.emotionalValue);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PlotEvent implements PlotEvent {
  const _PlotEvent(
      {required this.id,
      required this.storyId,
      required this.title,
      this.description = '',
      this.order = 0,
      this.chapterId,
      final List<String> characterIds = const [],
      this.locationId,
      this.status = EventStatus.idea,
      this.plotThread = 'Main Plot',
      this.emotionalValue = 0})
      : _characterIds = characterIds;
  factory _PlotEvent.fromJson(Map<String, dynamic> json) =>
      _$PlotEventFromJson(json);

  @override
  final String id;
  @override
  final String storyId;
  @override
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final int order;
  @override
  final String? chapterId;
  final List<String> _characterIds;
  @override
  @JsonKey()
  List<String> get characterIds {
    if (_characterIds is EqualUnmodifiableListView) return _characterIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_characterIds);
  }

  @override
  final String? locationId;
  @override
  @JsonKey()
  final EventStatus status;
  @override
  @JsonKey()
  final String plotThread;
  @override
  @JsonKey()
  final int emotionalValue;

  /// Create a copy of PlotEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PlotEventCopyWith<_PlotEvent> get copyWith =>
      __$PlotEventCopyWithImpl<_PlotEvent>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PlotEventToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PlotEvent &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storyId, storyId) || other.storyId == storyId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            const DeepCollectionEquality()
                .equals(other._characterIds, _characterIds) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.plotThread, plotThread) ||
                other.plotThread == plotThread) &&
            (identical(other.emotionalValue, emotionalValue) ||
                other.emotionalValue == emotionalValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      storyId,
      title,
      description,
      order,
      chapterId,
      const DeepCollectionEquality().hash(_characterIds),
      locationId,
      status,
      plotThread,
      emotionalValue);

  @override
  String toString() {
    return 'PlotEvent(id: $id, storyId: $storyId, title: $title, description: $description, order: $order, chapterId: $chapterId, characterIds: $characterIds, locationId: $locationId, status: $status, plotThread: $plotThread, emotionalValue: $emotionalValue)';
  }
}

/// @nodoc
abstract mixin class _$PlotEventCopyWith<$Res>
    implements $PlotEventCopyWith<$Res> {
  factory _$PlotEventCopyWith(
          _PlotEvent value, $Res Function(_PlotEvent) _then) =
      __$PlotEventCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String storyId,
      String title,
      String description,
      int order,
      String? chapterId,
      List<String> characterIds,
      String? locationId,
      EventStatus status,
      String plotThread,
      int emotionalValue});
}

/// @nodoc
class __$PlotEventCopyWithImpl<$Res> implements _$PlotEventCopyWith<$Res> {
  __$PlotEventCopyWithImpl(this._self, this._then);

  final _PlotEvent _self;
  final $Res Function(_PlotEvent) _then;

  /// Create a copy of PlotEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? storyId = null,
    Object? title = null,
    Object? description = null,
    Object? order = null,
    Object? chapterId = freezed,
    Object? characterIds = null,
    Object? locationId = freezed,
    Object? status = null,
    Object? plotThread = null,
    Object? emotionalValue = null,
  }) {
    return _then(_PlotEvent(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storyId: null == storyId
          ? _self.storyId
          : storyId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      chapterId: freezed == chapterId
          ? _self.chapterId
          : chapterId // ignore: cast_nullable_to_non_nullable
              as String?,
      characterIds: null == characterIds
          ? _self._characterIds
          : characterIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      locationId: freezed == locationId
          ? _self.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatus,
      plotThread: null == plotThread
          ? _self.plotThread
          : plotThread // ignore: cast_nullable_to_non_nullable
              as String,
      emotionalValue: null == emotionalValue
          ? _self.emotionalValue
          : emotionalValue // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on

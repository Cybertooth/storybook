// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plot_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlotEvent _$PlotEventFromJson(Map<String, dynamic> json) => _PlotEvent(
      id: json['id'] as String,
      storyId: json['storyId'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      chapterId: json['chapterId'] as String?,
      characterIds: (json['characterIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      locationId: json['locationId'] as String?,
      status: $enumDecodeNullable(_$EventStatusEnumMap, json['status']) ??
          EventStatus.idea,
      plotThread: json['plotThread'] as String? ?? 'Main Plot',
      emotionalValue: (json['emotionalValue'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PlotEventToJson(_PlotEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storyId': instance.storyId,
      'title': instance.title,
      'description': instance.description,
      'order': instance.order,
      'chapterId': instance.chapterId,
      'characterIds': instance.characterIds,
      'locationId': instance.locationId,
      'status': _$EventStatusEnumMap[instance.status]!,
      'plotThread': instance.plotThread,
      'emotionalValue': instance.emotionalValue,
    };

const _$EventStatusEnumMap = {
  EventStatus.idea: 'idea',
  EventStatus.drafted: 'drafted',
  EventStatus.finalEvent: 'finalEvent',
};

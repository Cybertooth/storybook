// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Location _$LocationFromJson(Map<String, dynamic> json) => _Location(
      id: json['id'] as String,
      storyId: json['storyId'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      sensorySight: json['sensorySight'] as String?,
      sensorySound: json['sensorySound'] as String?,
      sensorySmell: json['sensorySmell'] as String?,
      sensoryTouch: json['sensoryTouch'] as String?,
      sensoryTaste: json['sensoryTaste'] as String?,
    );

Map<String, dynamic> _$LocationToJson(_Location instance) => <String, dynamic>{
      'id': instance.id,
      'storyId': instance.storyId,
      'name': instance.name,
      'description': instance.description,
      'sensorySight': instance.sensorySight,
      'sensorySound': instance.sensorySound,
      'sensorySmell': instance.sensorySmell,
      'sensoryTouch': instance.sensoryTouch,
      'sensoryTaste': instance.sensoryTaste,
    };

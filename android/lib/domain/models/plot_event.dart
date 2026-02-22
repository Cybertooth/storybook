import 'package:freezed_annotation/freezed_annotation.dart';

part 'plot_event.freezed.dart';
part 'plot_event.g.dart';

enum EventStatus { idea, drafted, finalEvent }

@freezed
class PlotEvent with _$PlotEvent {
  const factory PlotEvent({
    required String id,
    required String storyId,
    required String title,
    @Default('') String description,
    @Default(0) int order,
    String? chapterId,
    @Default([]) List<String> characterIds,
    String? locationId,
    @Default(EventStatus.idea) EventStatus status,
    @Default('Main Plot') String plotThread,
    @Default(0) int emotionalValue,
  }) = _PlotEvent;

  factory PlotEvent.fromJson(Map<String, dynamic> json) => _$PlotEventFromJson(json);
}

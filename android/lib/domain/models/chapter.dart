import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter.freezed.dart';
part 'chapter.g.dart';

enum ChapterStatus { planned, drafting, completed }

@freezed
abstract class Chapter with _$Chapter {
  const factory Chapter({
    required String id,
    required String storyId,
    required String title,
    @Default('') String content,
    @Default(0) int order,
    @Default(ChapterStatus.planned) ChapterStatus status,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/repositories/local_story_repository.dart';
import '../../data/local/repositories/local_character_repository.dart';
import '../../data/local/repositories/local_location_repository.dart';
import '../../data/local/repositories/local_plot_event_repository.dart';
import '../../data/local/repositories/local_chapter_repository.dart';
import '../../data/local/repositories/local_note_repository.dart';
import '../../data/local/repositories/local_question_repository.dart';
import '../../data/local/repositories/local_relationship_repository.dart';
import '../../domain/repositories/story_repository.dart';
import '../../domain/repositories/character_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/plot_event_repository.dart';
import '../../domain/repositories/chapter_repository.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/question_repository.dart';
import '../../domain/repositories/relationship_repository.dart';
import 'database_provider.dart';

final storyRepositoryProvider = Provider<StoryRepository>(
  (ref) => LocalStoryRepository(ref.watch(databaseProvider)));
final characterRepositoryProvider = Provider<CharacterRepository>(
  (ref) => LocalCharacterRepository(ref.watch(databaseProvider)));
final locationRepositoryProvider = Provider<LocationRepository>(
  (ref) => LocalLocationRepository(ref.watch(databaseProvider)));
final plotEventRepositoryProvider = Provider<PlotEventRepository>(
  (ref) => LocalPlotEventRepository(ref.watch(databaseProvider)));
final chapterRepositoryProvider = Provider<ChapterRepository>(
  (ref) => LocalChapterRepository(ref.watch(databaseProvider)));
final noteRepositoryProvider = Provider<NoteRepository>(
  (ref) => LocalNoteRepository(ref.watch(databaseProvider)));
final questionRepositoryProvider = Provider<QuestionRepository>(
  (ref) => LocalQuestionRepository(ref.watch(databaseProvider)));
final relationshipRepositoryProvider = Provider<RelationshipRepository>(
  (ref) => LocalRelationshipRepository(ref.watch(databaseProvider)));

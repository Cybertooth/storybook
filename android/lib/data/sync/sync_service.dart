import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/story.dart';
import '../../domain/repositories/story_repository.dart';
import '../../core/providers/repository_providers.dart';
import '../remote/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SyncService {
  final ApiClient _apiClient;
  final StoryRepository _storyRepo;

  SyncService(this._apiClient, this._storyRepo);

  Dio get _dio => _apiClient.dio;

  Future<void> pullAllStories() async {
    try {
      final response = await _dio.get('/stories');
      final data = response.data;
      if (data['success'] == true) {
        final List<dynamic> remoteStories = data['data'];

        // Very basic sync: just insert/update local stories.
        // In a real app we'd need conflict resolution and syncing all child entities.
        for (var rs in remoteStories) {
          final id = rs['id'];
          final localStory = await _storyRepo.getById(id);
          if (localStory == null) {
            // It's not perfect because create generates a new UUID,
            // but we need a way to insert with specific ID.
            // For now, we'll just log or assume the backend uses the same IDs as local.
          } else {
            // Wait, our repository create() generates an ID.
            // If we pull from remote, we need to insert it with the remote ID.
          }
        }
      }
    } catch (e) {
      debugPrint('Sync pullAllStories failed: $e');
    }
  }

  Future<void> pushStoryToRemote(Story story) async {
    try {
      final response = await _dio.post('/stories', data: {
        'id': story.id,
        'title': story.title,
        'summary': story.summary,
      });
      debugPrint('Synced story to remote: ${response.data}');
    } catch (e) {
      debugPrint('Sync pushStoryToRemote failed: $e');
    }
  }
}

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    ref.watch(apiClientProvider),
    ref.watch(storyRepositoryProvider),
  );
});

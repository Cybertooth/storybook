import '../models/location.dart';

abstract class LocationRepository {
  Future<List<Location>> getAllForStory(String storyId);
  Future<Location?> getById(String id);
  Future<Location> create(Location location);
  Future<Location> update(Location location);
  Future<void> delete(String id);
}

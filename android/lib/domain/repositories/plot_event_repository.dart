import '../models/plot_event.dart';

abstract class PlotEventRepository {
  Future<List<PlotEvent>> getAllForStory(String storyId);
  Future<PlotEvent?> getById(String id);
  Future<PlotEvent> create(PlotEvent event);
  Future<PlotEvent> update(PlotEvent event);
  Future<void> delete(String id);
}

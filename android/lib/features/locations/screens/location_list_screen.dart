import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/location_providers.dart';
import 'location_detail_screen.dart';

class LocationListScreen extends ConsumerWidget {
  const LocationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locs = ref.watch(locationListProvider);
    return locs.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (list) => Scaffold(
        body: list.isEmpty
            ? const Center(child: Text('No locations yet.'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (ctx, i) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.place),
                    title: Text(list[i].name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: list[i].description.isNotEmpty ? Text(list[i].description, maxLines: 1) : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => ref.read(locationListProvider.notifier).deleteLocation(list[i].id),
                    ),
                    onTap: () => Navigator.push(ctx, MaterialPageRoute(
                      builder: (_) => LocationDetailScreen(location: list[i]),
                    )),
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreate(context, ref),
          child: const Icon(Icons.add_location),
        ),
      ),
    );
  }

  void _showCreate(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Location'),
        content: TextField(controller: ctrl, autofocus: true, decoration: const InputDecoration(labelText: 'Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                ref.read(locationListProvider.notifier).createLocation(ctrl.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

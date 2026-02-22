import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../codex/providers/character_providers.dart';
import '../../locations/providers/location_providers.dart';
import '../../timeline/providers/timeline_providers.dart';

class ReferenceDrawer extends ConsumerStatefulWidget {
  const ReferenceDrawer({super.key});

  @override
  ConsumerState<ReferenceDrawer> createState() => _State();
}

class _State extends ConsumerState<ReferenceDrawer> {
  final Set<String> _pinned = {};

  @override
  Widget build(BuildContext context) {
    final characters = ref.watch(characterListProvider).valueOrNull ?? [];
    final locations = ref.watch(locationListProvider).valueOrNull ?? [];
    final events = ref.watch(eventListProvider).valueOrNull ?? [];

    final pinnedChars =
        characters.where((c) => _pinned.contains(c.id)).toList();
    final pinnedLocs = locations.where((l) => _pinned.contains(l.id)).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, controller) => Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          if (pinnedChars.isNotEmpty || pinnedLocs.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(children: [
                Icon(Icons.push_pin, size: 14),
                SizedBox(width: 4),
                Text('Pinned',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ]),
            ),
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ...pinnedChars.map((c) => _PinnedChip(
                        label: c.name,
                        onRemove: () => setState(() => _pinned.remove(c.id)),
                      )),
                  ...pinnedLocs.map((l) => _PinnedChip(
                        label: l.name,
                        onRemove: () => setState(() => _pinned.remove(l.id)),
                      )),
                ],
              ),
            ),
            const Divider(),
          ],
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(tabs: [
                    Tab(text: 'Characters'),
                    Tab(text: 'Locations'),
                    Tab(text: 'Events'),
                  ]),
                  Expanded(
                    child: TabBarView(children: [
                      // Characters tab
                      ListView(
                          controller: controller,
                          children: characters
                              .map((c) => ListTile(
                                    leading:
                                        CircleAvatar(child: Text(c.name[0])),
                                    title: Text(c.name),
                                    subtitle: c.description.isNotEmpty
                                        ? Text(c.description, maxLines: 1)
                                        : null,
                                    trailing: IconButton(
                                      icon: Icon(
                                          _pinned.contains(c.id)
                                              ? Icons.push_pin
                                              : Icons.push_pin_outlined,
                                          size: 18),
                                      onPressed: () => setState(() {
                                        if (_pinned.contains(c.id)) {
                                          _pinned.remove(c.id);
                                        } else {
                                          _pinned.add(c.id);
                                        }
                                      }),
                                    ),
                                  ))
                              .toList()),
                      // Locations tab
                      ListView(
                          children: locations
                              .map((l) => ListTile(
                                    leading: const Icon(Icons.place),
                                    title: Text(l.name),
                                    subtitle: l.description.isNotEmpty
                                        ? Text(l.description, maxLines: 1)
                                        : null,
                                    trailing: IconButton(
                                      icon: Icon(
                                          _pinned.contains(l.id)
                                              ? Icons.push_pin
                                              : Icons.push_pin_outlined,
                                          size: 18),
                                      onPressed: () => setState(() {
                                        if (_pinned.contains(l.id)) {
                                          _pinned.remove(l.id);
                                        } else {
                                          _pinned.add(l.id);
                                        }
                                      }),
                                    ),
                                  ))
                              .toList()),
                      // Events tab
                      ListView(
                          children: events
                              .map((e) => ListTile(
                                    leading: const Icon(Icons.event),
                                    title: Text(e.title),
                                    subtitle: e.description.isNotEmpty
                                        ? Text(e.description, maxLines: 1)
                                        : null,
                                  ))
                              .toList()),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PinnedChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _PinnedChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 14),
      onDeleted: onRemove,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

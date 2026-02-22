import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/location.dart';
import '../providers/location_providers.dart';

class LocationDetailScreen extends ConsumerStatefulWidget {
  final Location location;
  const LocationDetailScreen({super.key, required this.location});

  @override
  ConsumerState<LocationDetailScreen> createState() => _State();
}

class _State extends ConsumerState<LocationDetailScreen> {
  late final TextEditingController _name, _desc, _sight, _sound, _smell, _touch, _taste;

  @override
  void initState() {
    super.initState();
    final l = widget.location;
    _name = TextEditingController(text: l.name);
    _desc = TextEditingController(text: l.description);
    _sight = TextEditingController(text: l.sensorySight ?? '');
    _sound = TextEditingController(text: l.sensorySound ?? '');
    _smell = TextEditingController(text: l.sensorySmell ?? '');
    _touch = TextEditingController(text: l.sensoryTouch ?? '');
    _taste = TextEditingController(text: l.sensoryTaste ?? '');
  }

  @override
  void dispose() {
    _name.dispose(); _desc.dispose(); _sight.dispose(); _sound.dispose();
    _smell.dispose(); _touch.dispose(); _taste.dispose();
    super.dispose();
  }

  void _save() {
    ref.read(locationListProvider.notifier).updateLocation(widget.location.copyWith(
      name: _name.text, description: _desc.text,
      sensorySight: _sight.text.isEmpty ? null : _sight.text,
      sensorySound: _sound.text.isEmpty ? null : _sound.text,
      sensorySmell: _smell.text.isEmpty ? null : _smell.text,
      sensoryTouch: _touch.text.isEmpty ? null : _touch.text,
      sensoryTaste: _taste.text.isEmpty ? null : _taste.text,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
        actions: [IconButton(onPressed: _save, icon: const Icon(Icons.save))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
          const SizedBox(height: 12),
          TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Description'), maxLines: 4),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('Sensory Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          for (final (ctrl, label) in [
            (_sight, 'Sight'), (_sound, 'Sound'), (_smell, 'Smell'),
            (_touch, 'Touch'), (_taste, 'Taste'),
          ]) ...[
            TextField(controller: ctrl, decoration: InputDecoration(labelText: label), maxLines: 2),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

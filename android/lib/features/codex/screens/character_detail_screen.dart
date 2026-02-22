import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/character.dart';
import '../providers/character_providers.dart';

class CharacterDetailScreen extends ConsumerStatefulWidget {
  final Character character;
  const CharacterDetailScreen({super.key, required this.character});

  @override
  ConsumerState<CharacterDetailScreen> createState() => _State();
}

class _State extends ConsumerState<CharacterDetailScreen> {
  late Character _char;
  late final TextEditingController _name, _desc, _arcLie, _arcTruth, _arcGhost;

  @override
  void initState() {
    super.initState();
    _char = widget.character;
    _name = TextEditingController(text: _char.name);
    _desc = TextEditingController(text: _char.description);
    _arcLie = TextEditingController(text: _char.arcLie ?? '');
    _arcTruth = TextEditingController(text: _char.arcTruth ?? '');
    _arcGhost = TextEditingController(text: _char.arcGhost ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _arcLie.dispose();
    _arcTruth.dispose();
    _arcGhost.dispose();
    super.dispose();
  }

  void _save() {
    ref.read(characterListProvider.notifier).updateCharacter(_char.copyWith(
          name: _name.text,
          description: _desc.text,
          arcLie: _arcLie.text.isEmpty ? null : _arcLie.text,
          arcTruth: _arcTruth.text.isEmpty ? null : _arcTruth.text,
          arcGhost: _arcGhost.text.isEmpty ? null : _arcGhost.text,
        ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character'),
        actions: [IconButton(onPressed: _save, icon: const Icon(Icons.save))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name')),
          const SizedBox(height: 12),
          DropdownButtonFormField<CharacterRole>(
            value: _char.role,
            items: CharacterRole.values
                .map((r) => DropdownMenuItem(value: r, child: Text(r.name)))
                .toList(),
            onChanged: (r) => setState(() => _char = _char.copyWith(role: r!)),
            decoration: const InputDecoration(labelText: 'Role'),
          ),
          const SizedBox(height: 12),
          TextField(
              controller: _desc,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 4),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('Character Arc',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          TextField(
              controller: _arcLie,
              decoration: const InputDecoration(labelText: 'The Lie (flaw)')),
          const SizedBox(height: 12),
          TextField(
              controller: _arcTruth,
              decoration:
                  const InputDecoration(labelText: 'The Truth (growth)')),
          const SizedBox(height: 12),
          TextField(
              controller: _arcGhost,
              decoration: const InputDecoration(
                  labelText: 'The Ghost (backstory wound)')),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../domain/models/character.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const CharacterCard({super.key, required this.character, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(child: Text(character.name[0].toUpperCase())),
        title: Text(character.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(character.role.name),
        trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: onDelete),
        onTap: onTap,
      ),
    );
  }
}

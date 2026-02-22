import 'package:flutter/material.dart';

class AiNoKeyBanner extends StatelessWidget {
  const AiNoKeyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.key, color: Theme.of(context).colorScheme.onErrorContainer),
          const SizedBox(width: 8),
          Expanded(child: Text(
            'No API key configured. Go to More → Settings to add your Gemini key.',
            style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
          )),
        ],
      ),
    );
  }
}

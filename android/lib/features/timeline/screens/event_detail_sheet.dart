import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/plot_event.dart';
import '../providers/timeline_providers.dart';

class EventDetailSheet extends ConsumerStatefulWidget {
  final PlotEvent event;
  const EventDetailSheet({super.key, required this.event});

  @override
  ConsumerState<EventDetailSheet> createState() => _State();
}

class _State extends ConsumerState<EventDetailSheet> {
  late final TextEditingController _title, _desc;
  late EventStatus _status;
  late int _emotionalValue;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.event.title);
    _desc = TextEditingController(text: widget.event.description);
    _status = widget.event.status;
    _emotionalValue = widget.event.emotionalValue;
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  void _save() {
    ref.read(eventListProvider.notifier).updateEvent(widget.event.copyWith(
          title: _title.text,
          description: _desc.text,
          status: _status,
          emotionalValue: _emotionalValue,
        ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Edit Event',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const Spacer(),
              IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    ref
                        .read(eventListProvider.notifier)
                        .deleteEvent(widget.event.id);
                    Navigator.pop(context);
                  }),
              FilledButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height: 8),
          TextField(
              controller: _desc,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3),
          const SizedBox(height: 8),
          DropdownButtonFormField<EventStatus>(
            value: _status,
            items: EventStatus.values
                .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                .toList(),
            onChanged: (s) => setState(() => _status = s!),
            decoration: const InputDecoration(labelText: 'Status'),
          ),
          const SizedBox(height: 8),
          Row(children: [
            const Text('Emotional Value: '),
            Expanded(
                child: Slider(
              value: _emotionalValue.toDouble(),
              min: -5,
              max: 5,
              divisions: 10,
              label: '$_emotionalValue',
              onChanged: (v) => setState(() => _emotionalValue = v.round()),
            )),
            Text('$_emotionalValue',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
        ],
      ),
    );
  }
}

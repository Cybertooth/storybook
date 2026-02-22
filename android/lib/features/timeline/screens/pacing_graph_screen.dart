import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/timeline_providers.dart';

class PacingGraphScreen extends ConsumerWidget {
  const PacingGraphScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventListProvider);
    return eventsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (events) {
        if (events.isEmpty) {
          return const Center(child: Text('Add events to the timeline to see the pacing graph.'));
        }
        final spots = events.asMap().entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.emotionalValue.toDouble()))
            .toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Emotional Value Over Time',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              const Text('Sagging middles show as flat lines near 0.',
                  style: TextStyle(fontSize: 12)),
              const SizedBox(height: 24),
              SizedBox(
                height: 300,
                child: LineChart(LineChartData(
                  minY: -5, maxY: 5,
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (v, _) =>
                            Text(v.toInt().toString(), style: const TextStyle(fontSize: 10)),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          final i = v.toInt();
                          if (i < 0 || i >= events.length) return const Text('');
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              events[i].title.length > 8 ? '${events[i].title.substring(0, 8)}…' : events[i].title,
                              style: const TextStyle(fontSize: 9),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                )),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                children: [
                  _Legend(color: Colors.green, label: 'High tension (+)'),
                  _Legend(color: Colors.grey, label: 'Neutral (0)'),
                  _Legend(color: Colors.red, label: 'Low/dark (-)'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 12)),
    ],
  );
}

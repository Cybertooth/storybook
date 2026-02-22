import 'package:flutter/material.dart';

class BeatSheetScreen extends StatelessWidget {
  const BeatSheetScreen({super.key});

  static const _saveTheCat = [
    (1, 'Opening Image', 'A snapshot of the hero\'s problem world before the change.'),
    (2, 'Theme Stated', 'The thematic premise is stated (often by someone other than the hero).'),
    (3, 'Set-Up', 'Introduce all the characters. Show the hero\'s flaws and desires.'),
    (4, 'Catalyst', 'The life-changing event that kicks the story into gear.'),
    (5, 'Debate', 'The hero hesitates. Should I go? What if I fail?'),
    (6, 'Break into Two', 'The hero enters the upside-down world — Act II begins.'),
    (7, 'B Story', 'The love story / mentor relationship begins. Carries the theme.'),
    (8, 'Fun and Games', 'The "promise of the premise" — why we bought the ticket.'),
    (9, 'Midpoint', 'A false victory or false defeat. Stakes are raised.'),
    (10, 'Bad Guys Close In', 'Internal doubts, external enemies all close in.'),
    (11, 'All Is Lost', 'The worst thing possible. The whiff of death.'),
    (12, 'Dark Night of the Soul', 'The hero has nowhere to turn and digs deep.'),
    (13, 'Break into Three', 'The solution found — hero decides to fight back.'),
    (14, 'Finale', 'Storm the castle. Execute the plan. Change the world.'),
    (15, 'Final Image', 'The mirror of the Opening Image. Shows how much has changed.'),
  ];

  static const _heroJourney = [
    (1, 'Ordinary World', 'The hero\'s normal life before the adventure begins.'),
    (2, 'Call to Adventure', 'The hero is presented with a challenge or problem.'),
    (3, 'Refusal of the Call', 'The hero hesitates or refuses the challenge.'),
    (4, 'Meeting the Mentor', 'The hero encounters someone who gives wisdom or tools.'),
    (5, 'Crossing the Threshold', 'The hero commits and enters the special world.'),
    (6, 'Tests, Allies, Enemies', 'The hero faces challenges and makes friends/foes.'),
    (7, 'Approach to Inmost Cave', 'The hero nears the dangerous place of the ordeal.'),
    (8, 'Ordeal', 'The hero faces their greatest fear. Death and rebirth.'),
    (9, 'Reward (Seizing the Sword)', 'The hero takes possession of the treasure.'),
    (10, 'Road Back', 'The hero begins the journey back, often pursued.'),
    (11, 'Resurrection', 'A final test where the hero is transformed.'),
    (12, 'Return with the Elixir', 'The hero returns changed, with something to benefit the world.'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Beat Sheets'),
          bottom: const TabBar(tabs: [Tab(text: 'Save the Cat'), Tab(text: 'Hero\'s Journey')]),
        ),
        body: TabBarView(children: [
          _BeatList(beats: _saveTheCat),
          _BeatList(beats: _heroJourney),
        ]),
      ),
    );
  }
}

class _BeatList extends StatelessWidget {
  final List<(int, String, String)> beats;
  const _BeatList({required this.beats});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: beats.length,
      itemBuilder: (ctx, i) {
        final (num, name, desc) = beats[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('$num', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(desc),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}

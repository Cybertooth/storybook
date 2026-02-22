import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef UndoCommand = Future<void> Function();

class UndoStack extends Notifier<List<UndoCommand>> {
  static const _maxSize = 50;

  @override
  List<UndoCommand> build() => [];

  void push(UndoCommand command) {
    final next = [...state, command];
    // Cap at max size to avoid unbounded memory use
    state = next.length > _maxSize ? next.sublist(next.length - _maxSize) : next;
  }

  Future<void> undo() async {
    if (state.isEmpty) return;
    final command = state.last;
    state = state.sublist(0, state.length - 1);
    await command();
  }

  bool get canUndo => state.isNotEmpty;
}

final undoStackProvider =
    NotifierProvider<UndoStack, List<UndoCommand>>(UndoStack.new);

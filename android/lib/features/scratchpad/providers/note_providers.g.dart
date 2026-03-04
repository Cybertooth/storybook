// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NoteList)
final noteListProvider = NoteListProvider._();

final class NoteListProvider
    extends $AsyncNotifierProvider<NoteList, List<Note>> {
  NoteListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'noteListProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$noteListHash();

  @$internal
  @override
  NoteList create() => NoteList();
}

String _$noteListHash() => r'a167a6340c8e55fd93d40d818606c51aeba99502';

abstract class _$NoteList extends $AsyncNotifier<List<Note>> {
  FutureOr<List<Note>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Note>>, List<Note>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Note>>, List<Note>>,
        AsyncValue<List<Note>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

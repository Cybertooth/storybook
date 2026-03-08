// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NoteFilter)
final noteFilterProvider = NoteFilterProvider._();

final class NoteFilterProvider extends $NotifierProvider<NoteFilter, String?> {
  NoteFilterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'noteFilterProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$noteFilterHash();

  @$internal
  @override
  NoteFilter create() => NoteFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$noteFilterHash() => r'25cf526334da4d600ed8ddb9524dc0ee52a94e3b';

abstract class _$NoteFilter extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String?, String?>, String?, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

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

String _$noteListHash() => r'b368b1138a80d1167faa0652c959abb8efe111c1';

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

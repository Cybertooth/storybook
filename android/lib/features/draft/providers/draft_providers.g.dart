// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChapterList)
final chapterListProvider = ChapterListProvider._();

final class ChapterListProvider
    extends $AsyncNotifierProvider<ChapterList, List<Chapter>> {
  ChapterListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'chapterListProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$chapterListHash();

  @$internal
  @override
  ChapterList create() => ChapterList();
}

String _$chapterListHash() => r'1850014087c83271365f13ee7e1321dd0bfc7f4e';

abstract class _$ChapterList extends $AsyncNotifier<List<Chapter>> {
  FutureOr<List<Chapter>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Chapter>>, List<Chapter>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Chapter>>, List<Chapter>>,
        AsyncValue<List<Chapter>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ActiveChapter)
final activeChapterProvider = ActiveChapterProvider._();

final class ActiveChapterProvider
    extends $NotifierProvider<ActiveChapter, Chapter?> {
  ActiveChapterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'activeChapterProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$activeChapterHash();

  @$internal
  @override
  ActiveChapter create() => ActiveChapter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Chapter? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Chapter?>(value),
    );
  }
}

String _$activeChapterHash() => r'258cac9a59cff3fb370239534bdd490f8989503a';

abstract class _$ActiveChapter extends $Notifier<Chapter?> {
  Chapter? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Chapter?, Chapter?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Chapter?, Chapter?>, Chapter?, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

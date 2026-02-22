// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chapterListHash() => r'a0ab6267ee66542437938c9261e4f40d5e60965f';

/// See also [ChapterList].
@ProviderFor(ChapterList)
final chapterListProvider =
    AutoDisposeAsyncNotifierProvider<ChapterList, List<Chapter>>.internal(
  ChapterList.new,
  name: r'chapterListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chapterListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChapterList = AutoDisposeAsyncNotifier<List<Chapter>>;
String _$activeChapterHash() => r'c029452bc4a9f9bd151c496832be54ed86821945';

/// See also [ActiveChapter].
@ProviderFor(ActiveChapter)
final activeChapterProvider =
    AutoDisposeNotifierProvider<ActiveChapter, Chapter?>.internal(
  ActiveChapter.new,
  name: r'activeChapterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeChapterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ActiveChapter = AutoDisposeNotifier<Chapter?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CharacterList)
final characterListProvider = CharacterListProvider._();

final class CharacterListProvider
    extends $AsyncNotifierProvider<CharacterList, List<Character>> {
  CharacterListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'characterListProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$characterListHash();

  @$internal
  @override
  CharacterList create() => CharacterList();
}

String _$characterListHash() => r'0a0ba5bc353c6eeea933820014af54f51fb88b86';

abstract class _$CharacterList extends $AsyncNotifier<List<Character>> {
  FutureOr<List<Character>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Character>>, List<Character>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Character>>, List<Character>>,
        AsyncValue<List<Character>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

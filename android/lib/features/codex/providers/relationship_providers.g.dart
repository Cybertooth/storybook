// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RelationshipList)
final relationshipListProvider = RelationshipListProvider._();

final class RelationshipListProvider
    extends $AsyncNotifierProvider<RelationshipList, List<Relationship>> {
  RelationshipListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'relationshipListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$relationshipListHash();

  @$internal
  @override
  RelationshipList create() => RelationshipList();
}

String _$relationshipListHash() => r'33bfbac7945b247fb244dfb1d0887c08cd627490';

abstract class _$RelationshipList extends $AsyncNotifier<List<Relationship>> {
  FutureOr<List<Relationship>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<Relationship>>, List<Relationship>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Relationship>>, List<Relationship>>,
        AsyncValue<List<Relationship>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QuestionList)
final questionListProvider = QuestionListProvider._();

final class QuestionListProvider
    extends $AsyncNotifierProvider<QuestionList, List<UnresolvedQuestion>> {
  QuestionListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'questionListProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$questionListHash();

  @$internal
  @override
  QuestionList create() => QuestionList();
}

String _$questionListHash() => r'1e0e0aa487944495d73ff52206034bde1a0c662a';

abstract class _$QuestionList extends $AsyncNotifier<List<UnresolvedQuestion>> {
  FutureOr<List<UnresolvedQuestion>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<UnresolvedQuestion>>, List<UnresolvedQuestion>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<UnresolvedQuestion>>,
            List<UnresolvedQuestion>>,
        AsyncValue<List<UnresolvedQuestion>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

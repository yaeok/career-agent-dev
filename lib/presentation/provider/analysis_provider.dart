import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_career_app/application/usecase/analysis_usecase.dart';
import 'package:your_career_app/presentation/provider/chat_provider.dart';
import 'repository_provider.dart';

/// AnalysisUsecaseを提供するProvider
final analysisUsecaseProvider = Provider<AnalysisUsecase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final diaryRepository = ref.watch(diaryRepositoryProvider);
  final analysisRepository = ref.watch(analysisRepositoryProvider);
  final analysisResultRepository = ref.watch(analysisResultRepositoryProvider);
  final chatRepository = ref.watch(chatRepositoryProvider);
  return AnalysisUsecase(
    authRepository,
    diaryRepository,
    analysisRepository,
    analysisResultRepository,
    chatRepository,
  );
});

/// 分析結果の状態を管理するStateNotifier
class AnalysisStateNotifier extends StateNotifier<AsyncValue<String?>> {
  AnalysisStateNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> executeAnalysis() async {
    // 実行中はローディング状態にする
    state = const AsyncValue.loading();
    // 実行結果をstateに格納する
    state = await AsyncValue.guard(() {
      return ref.read(analysisUsecaseProvider).executeAnalysis();
    });
  }
}

/// AnalysisStateNotifierを提供するProvider
final analysisResultProvider =
    StateNotifierProvider<AnalysisStateNotifier, AsyncValue<String?>>((ref) {
      return AnalysisStateNotifier(ref);
    });

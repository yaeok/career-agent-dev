import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_career_app/application/usecase/diary_usecase.dart';
import 'package:your_career_app/domain/model/diary_entry.dart';
import 'auth_provider.dart';
import 'repository_provider.dart';

/// DiaryUsecaseを提供するProvider
/// UI層はこのProviderを介して、日記の追加・更新・削除などの操作を実行します。
final diaryUsecaseProvider = Provider<DiaryUsecase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final diaryRepository = ref.watch(diaryRepositoryProvider);
  return DiaryUsecase(authRepository, diaryRepository);
});

/// ログインユーザーの日記一覧を提供するStreamProvider
/// 認証状態を監視し、ログインしていればそのユーザーの日記一覧をStreamで提供します。
/// ユーザーがログアウトすると、自動的に空のリストを返すようになります。
final diariesProvider = StreamProvider<List<DiaryEntry>>((ref) {
  final authState = ref.watch(authStateProvider);

  // ユーザーがログインしている場合のみ、日記のStreamを購読する
  if (authState.valueOrNull != null) {
    return ref.watch(diaryUsecaseProvider).watchDiaries();
  } else {
    // ログインしていない場合は空のリストを返すStreamを返す
    return Stream.value([]);
  }
});

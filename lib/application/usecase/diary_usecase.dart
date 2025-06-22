import 'package:your_career_app/domain/model/diary_entry.dart';
import 'package:your_career_app/domain/repository/auth_repository.dart';
import 'package:your_career_app/domain/repository/diary_repository.dart';

class DiaryUsecase {
  DiaryUsecase(this._authRepository, this._diaryRepository);

  final AuthRepository _authRepository;
  final DiaryRepository _diaryRepository;

  /// 現在のユーザーIDを取得する内部ヘルパー
  Future<String> _getUserId() async {
    final user = await _authRepository.getCurrentUser();
    if (user == null) {
      throw Exception('Not authenticated'); // ユーザーがログインしていない場合はエラー
    }
    return user.uid;
  }

  /// ログインユーザーの日記一覧を監視する
  Stream<List<DiaryEntry>> watchDiaries() async* {
    final userId = await _getUserId();
    yield* _diaryRepository.watchDiaries(userId);
  }

  /// 新しい日記を追加する
  Future<void> addDiary(DiaryEntry diary) async {
    final userId = await _getUserId();
    await _diaryRepository.addDiary(userId, diary);
  }

  /// 既存の日記を更新する
  Future<void> updateDiary(DiaryEntry diary) async {
    final userId = await _getUserId();
    await _diaryRepository.updateDiary(userId, diary);
  }

  /// 日記を削除する
  Future<void> deleteDiary(String diaryId) async {
    final userId = await _getUserId();
    await _diaryRepository.deleteDiary(userId, diaryId);
  }
}

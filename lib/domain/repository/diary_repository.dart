import 'package:your_career_app/domain/model/diary_entry.dart';

abstract class DiaryRepository {
  /// 特定ユーザーの日記一覧を取得する (Stream)
  Stream<List<DiaryEntry>> watchDiaries(String userId);

  /// 新しい日記を追加する
  Future<void> addDiary(String userId, DiaryEntry diary);

  /// 既存の日記を更新する
  Future<void> updateDiary(String userId, DiaryEntry diary);

  /// 日記を削除する
  Future<void> deleteDiary(String userId, String diaryId);
}

import 'package:your_career_app/domain/model/diary_entry.dart';

abstract class AnalysisRepository {
  /// 日記のリストを受け取り、自己分析の結果を文字列として返す
  Future<String> analyzeDiaries(List<DiaryEntry> diaries);
}

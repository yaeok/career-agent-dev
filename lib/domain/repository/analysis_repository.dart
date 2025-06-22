import 'package:your_career_app/domain/model/chat_message.dart';
import 'package:your_career_app/domain/model/diary_entry.dart';

abstract class AnalysisRepository {
  /// 日記のリストを受け取り、自己分析の結果を文字列として返す
  Future<String> analyzeDiariesAndChat(
    List<DiaryEntry> diaries,
    List<ChatMessage> messages,
  );
}

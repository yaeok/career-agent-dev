import 'package:your_career_app/domain/model/chat_message.dart';

abstract class ChatRepository {
  /// チャットメッセージの一覧をStreamで監視する
  Stream<List<ChatMessage>> watchChatMessages(String userId);

  /// 新しいチャットメッセージを追加する
  Future<void> addChatMessage(String userId, ChatMessage message);

  /// AIエージェントからの返信を取得する
  Future<String> getAgentReply(List<ChatMessage> history);
}

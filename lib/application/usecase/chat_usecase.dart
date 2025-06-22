import 'package:your_career_app/domain/model/chat_message.dart';
import 'package:your_career_app/domain/repository/auth_repository.dart';
import 'package:your_career_app/domain/repository/chat_repository.dart';

class ChatUsecase {
  ChatUsecase(this._authRepository, this._chatRepository);
  final AuthRepository _authRepository;
  final ChatRepository _chatRepository;

  Future<String> _getUserId() async {
    final user = await _authRepository.getCurrentUser();
    if (user == null) throw Exception('Not authenticated');
    return user.uid;
  }

  Stream<List<ChatMessage>> watchChatMessages() async* {
    final userId = await _getUserId();
    yield* _chatRepository.watchChatMessages(userId);
  }

  Future<void> sendMessage(String text) async {
    final userId = await _getUserId();
    final userMessage = ChatMessage(
      text: text,
      sender: SenderRole.user,
      createdAt: DateTime.now(),
    );
    await _chatRepository.addChatMessage(userId, userMessage);

    // 履歴を取得してエージェントの返信を生成
    final history = await _chatRepository.watchChatMessages(userId).first;
    final agentReplyText = await _chatRepository.getAgentReply(history);
    final agentMessage = ChatMessage(
      text: agentReplyText,
      sender: SenderRole.agent,
      createdAt: DateTime.now(),
    );
    await _chatRepository.addChatMessage(userId, agentMessage);
  }
}

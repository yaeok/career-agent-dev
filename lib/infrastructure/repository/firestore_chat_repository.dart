import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:your_career_app/domain/model/chat_message.dart';
import 'package:your_career_app/domain/repository/chat_repository.dart';

class FirestoreChatRepository implements ChatRepository {
  FirestoreChatRepository(this._firestore, this._apiKey);
  final FirebaseFirestore _firestore;
  final String _apiKey;

  CollectionReference<ChatMessage> _chatMessagesRef(String userId) => _firestore
      .collection('users')
      .doc(userId)
      .collection('chat_messages')
      .withConverter<ChatMessage>(
        fromFirestore:
            (snapshot, _) => ChatMessage.fromJson(
              snapshot.data()!,
            ).copyWith(id: snapshot.id),
        toFirestore: (message, _) => message.toJson(),
      );

  @override
  Stream<List<ChatMessage>> watchChatMessages(String userId) {
    final query = _chatMessagesRef(
      userId,
    ).orderBy('createdAt', descending: true);
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Future<void> addChatMessage(String userId, ChatMessage message) async {
    await _chatMessagesRef(userId).add(message);
  }

  @override
  Future<String> getAgentReply(List<ChatMessage> history) async {
    const model = 'gemini-1.5-flash';
    const apiEndpoint =
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent';
    final prompt = _createChatPrompt(history);

    final response = await http.post(
      Uri.parse('$apiEndpoint?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception(
        'Failed to get agent reply. Status code: ${response.statusCode}',
      );
    }
  }

  String _createChatPrompt(List<ChatMessage> history) {
    final formattedHistory = history
        .reversed // 古い順に並び替え
        .map(
          (m) => '${m.sender == SenderRole.user ? 'User' : 'Agent'}: ${m.text}',
        )
        .join('\n');

    return '''
あなたは、ユーザーのキャリア形成をサポートする、親しみやすいAIキャリアエージェントです。
以下の会話履歴に基づき、ユーザーの最後のメッセージに対して、簡潔で役立つ返信をしてください。

# 制約
- 100文字以内で、日本語で回答してください。
- 友人やメンターのように、優しく励ますような口調で話してください。

# 会話履歴
$formattedHistory

# あなたの返信:
''';
  }
}

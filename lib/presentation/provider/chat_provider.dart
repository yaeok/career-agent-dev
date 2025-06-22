import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_career_app/application/usecase/chat_usecase.dart';
import 'package:your_career_app/domain/model/chat_message.dart';
import 'package:your_career_app/domain/repository/chat_repository.dart';
import 'package:your_career_app/infrastructure/repository/firestore_chat_repository.dart';
import 'package:your_career_app/presentation/provider/auth_provider.dart';
import 'package:your_career_app/presentation/provider/repository_provider.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  if (apiKey == null) throw Exception('GEMINI_API_KEY not found');
  return FirestoreChatRepository(firestore, apiKey);
});

final chatUsecaseProvider = Provider<ChatUsecase>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final chatRepo = ref.watch(chatRepositoryProvider);
  return ChatUsecase(authRepo, chatRepo);
});

final chatMessagesProvider = StreamProvider.autoDispose<List<ChatMessage>>((
  ref,
) {
  // authStateを監視して、ログアウト時などに自動で再生成されるようにする
  ref.watch(authStateProvider);
  return ref.watch(chatUsecaseProvider).watchChatMessages();
});

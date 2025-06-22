import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_career_app/domain/repository/analysis_repository.dart';
import 'package:your_career_app/domain/repository/auth_repository.dart';
import 'package:your_career_app/domain/repository/diary_repository.dart';
import 'package:your_career_app/domain/repository/project_experience_repository.dart';
import 'package:your_career_app/infrastructure/repository/firebase_auth_repository.dart';
import 'package:your_career_app/infrastructure/repository/firestore_diary_repository.dart';
import 'package:your_career_app/infrastructure/repository/firestore_project_experience_repository.dart';
import 'package:your_career_app/infrastructure/repository/gemini_analysis_repository.dart';

//--- 認証関連 ---
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return FirebaseAuthRepository(auth);
});

/// FirebaseFirestoreのインスタンスを提供するProvider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// DiaryRepositoryの実装（FirestoreDiaryRepository）を提供するProvider
final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirestoreDiaryRepository(firestore);
});

/// AnalysisRepositoryの実装（GeminiAnalysisRepository）を提供するProvider
final analysisRepositoryProvider = Provider<AnalysisRepository>((ref) {
  // .envからAPIキーを読み込む
  final apiKey = dotenv.env['GEMINI_API_KEY'];

  // APIキーが設定されているかチェック
  if (apiKey == null || apiKey.isEmpty) {
    throw Exception('GEMINI_API_KEY is not found in .env file');
  }

  return GeminiAnalysisRepository(apiKey);
});

/// ProjectExperienceRepositoryの実装を提供するProvider
final projectExperienceRepositoryProvider =
    Provider<ProjectExperienceRepository>((ref) {
      final firestore = ref.watch(firestoreProvider);
      return FirestoreProjectExperienceRepository(firestore);
    });

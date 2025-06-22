import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_career_app/domain/model/diary_entry.dart';
import 'package:your_career_app/domain/repository/diary_repository.dart';

class FirestoreDiaryRepository implements DiaryRepository {
  FirestoreDiaryRepository(this._firestore);
  final FirebaseFirestore _firestore;

  // ユーザーごとの日記コレクションへの参照
  CollectionReference<DiaryEntry> _diariesRef(String userId) => _firestore
      .collection('users')
      .doc(userId)
      .collection('diaries')
      .withConverter<DiaryEntry>(
        fromFirestore:
            (snapshot, _) =>
                DiaryEntry.fromJson(snapshot.data()!).copyWith(id: snapshot.id),
        toFirestore: (diary, _) => diary.toJson(),
      );

  @override
  Stream<List<DiaryEntry>> watchDiaries(String userId) {
    final query = _diariesRef(userId).orderBy('createdAt', descending: true);
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Future<void> addDiary(String userId, DiaryEntry diary) async {
    try {
      await _diariesRef(userId).add(diary);
    } catch (e) {
      // エラーハンドリングはUsecase層で行う
      rethrow;
    }
  }

  @override
  Future<void> updateDiary(String userId, DiaryEntry diary) async {
    try {
      if (diary.id == null) {
        throw Exception('Diary ID is null, cannot update.');
      }
      await _diariesRef(userId).doc(diary.id).update(diary.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteDiary(String userId, String diaryId) async {
    try {
      await _diariesRef(userId).doc(diaryId).delete();
    } catch (e) {
      rethrow;
    }
  }
}

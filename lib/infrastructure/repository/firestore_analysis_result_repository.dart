import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_career_app/domain/model/analysis_result.dart';
import 'package:your_career_app/domain/repository/analysis_result_repository.dart';

class FirestoreAnalysisResultRepository implements AnalysisResultRepository {
  FirestoreAnalysisResultRepository(this._firestore);
  final FirebaseFirestore _firestore;

  // 常に最新の結果をこのIDのドキュメントに保存する
  static const String _docId = 'latest';

  // 分析結果ドキュメントへの参照
  DocumentReference<AnalysisResult> _analysisResultRef(String userId) =>
      _firestore
          .collection('users')
          .doc(userId)
          .collection('analysis_results')
          .doc(_docId)
          .withConverter<AnalysisResult>(
            fromFirestore:
                (snapshot, _) => AnalysisResult.fromJson(snapshot.data()!),
            toFirestore: (result, _) => result.toJson(),
          );

  @override
  Stream<AnalysisResult?> watchAnalysisResult(String userId) {
    return _analysisResultRef(userId).snapshots().map((snapshot) {
      return snapshot.exists ? snapshot.data() : null;
    });
  }

  @override
  Future<void> saveAnalysisResult(String userId, AnalysisResult result) async {
    // setメソッドでドキュメントを上書き保存する
    await _analysisResultRef(userId).set(result, SetOptions(merge: true));
  }
}

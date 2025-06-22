import 'package:your_career_app/domain/model/analysis_result.dart';

abstract class AnalysisResultRepository {
  /// 分析結果をStreamで監視する
  Stream<AnalysisResult?> watchAnalysisResult(String userId);

  /// 分析結果を保存（更新）する
  Future<void> saveAnalysisResult(String userId, AnalysisResult result);
}

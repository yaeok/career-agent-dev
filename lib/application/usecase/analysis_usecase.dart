import 'package:your_career_app/domain/repository/analysis_repository.dart';
import 'package:your_career_app/domain/repository/auth_repository.dart';
import 'package:your_career_app/domain/repository/diary_repository.dart';

class AnalysisUsecase {
  AnalysisUsecase(
    this._authRepository,
    this._diaryRepository,
    this._analysisRepository,
  );

  final AuthRepository _authRepository;
  final DiaryRepository _diaryRepository;
  final AnalysisRepository _analysisRepository;

  /// 日記の分析を実行する
  Future<String> executeAnalysis() async {
    final user = await _authRepository.getCurrentUser();
    if (user == null) {
      throw Exception('Not authenticated');
    }

    // watchDiariesはStreamなので、最初のデータ（現在の全日記）を取得するために first を使う
    final diaries = await _diaryRepository.watchDiaries(user.uid).first;

    if (diaries.isEmpty) {
      return '分析できる日記がありません。まずは日記をいくつか書いてみましょう。';
    }

    final result = await _analysisRepository.analyzeDiaries(diaries);
    return result;
  }
}

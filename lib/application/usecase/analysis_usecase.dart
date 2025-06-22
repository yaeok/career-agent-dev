import 'package:your_career_app/domain/model/analysis_result.dart';
import 'package:your_career_app/domain/repository/analysis_repository.dart';
import 'package:your_career_app/domain/repository/analysis_result_repository.dart';
import 'package:your_career_app/domain/repository/auth_repository.dart';
import 'package:your_career_app/domain/repository/chat_repository.dart';
import 'package:your_career_app/domain/repository/diary_repository.dart';

class AnalysisUsecase {
  AnalysisUsecase(
    this._authRepository,
    this._diaryRepository,
    this._analysisRepository,
    this._analysisResultRepository,
    this._chatRepository,
  );

  final AuthRepository _authRepository;
  final DiaryRepository _diaryRepository;
  final AnalysisRepository _analysisRepository;
  final AnalysisResultRepository _analysisResultRepository;
  final ChatRepository _chatRepository;

  /// 日記とチャットの分析を実行し、結果を保存する
  Future<String> executeAnalysis() async {
    final user = await _authRepository.getCurrentUser();
    if (user == null) {
      throw Exception('Not authenticated');
    }

    // 日記とチャットの両方を取得
    final diaries = await _diaryRepository.watchDiaries(user.uid).first;
    final messages = await _chatRepository.watchChatMessages(user.uid).first;

    if (diaries.isEmpty && messages.isEmpty) {
      return '分析できる日記やチャットがありません。まずは日記を書いたり、AIとチャットしてみましょう。';
    }

    // Geminiに分析を依頼
    final resultText = await _analysisRepository.analyzeDiariesAndChat(
      diaries,
      messages,
    );

    try {
      final analysisResult = _parseAnalysisResult(resultText);
      await _analysisResultRepository.saveAnalysisResult(
        user.uid,
        analysisResult,
      );
    } catch (e) {
      print('Failed to parse or save analysis result: $e');
    }

    return resultText;
  }

  /// Geminiからのレスポンス(Markdown)をパースしてオブジェクトに変換する
  AnalysisResult _parseAnalysisResult(String text) {
    final strengths = _parseListContent(text, "1. あなたの強み");
    final weaknesses = _parseListContent(text, "2. あなたの弱み・課題");
    final selfPR = _parseTextContent(text, "3. 強みを活かす自己PRのヒント");

    return AnalysisResult(
      strengths: strengths,
      weaknesses: weaknesses,
      selfPR: selfPR,
    );
  }

  List<String> _parseListContent(String text, String sectionTitle) {
    final regex = RegExp(
      r'##\s*' + sectionTitle + r'\s*([\s\S]*?)(?=\n##|$)',
      multiLine: true,
    );
    final match = regex.firstMatch(text);
    if (match == null) return [];

    final content = match.group(1)!.trim();
    return content
        .split('\n')
        .map((line) => line.trim().replaceFirst(RegExp(r'^\s*-\s*'), '').trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  String _parseTextContent(String text, String sectionTitle) {
    final regex = RegExp(
      r'##\s*' + sectionTitle + r'\s*([\s\S]*?)(?=\n##|$)',
      multiLine: true,
    );
    final match = regex.firstMatch(text);
    if (match == null) return "";
    return match.group(1)!.trim();
  }
}

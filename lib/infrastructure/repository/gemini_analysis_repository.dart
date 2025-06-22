import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:your_career_app/domain/model/diary_entry.dart';
import 'package:your_career_app/domain/repository/analysis_repository.dart';

class GeminiAnalysisRepository implements AnalysisRepository {
  GeminiAnalysisRepository(this._apiKey);

  final String _apiKey;
  static const _model = 'gemini-1.5-flash'; // 使用するモデル
  static const _apiEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent';

  @override
  Future<String> analyzeDiaries(List<DiaryEntry> diaries) async {
    if (diaries.isEmpty) {
      return '分析する日記がありません。';
    }

    final prompt = _createPrompt(diaries);

    final response = await http.post(
      Uri.parse('$_apiEndpoint?key=$_apiKey'),
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
      // Geminiからのレスポンス構造に合わせてテキストを抽出
      return body['candidates'][0]['content']['parts'][0]['text'];
    } else {
      // エラーレスポンスの内容をログに出力するとデバッグに役立ちます
      print('Gemini API Error: ${response.body}');
      throw Exception(
        'Failed to get analysis from Gemini API. Status code: ${response.statusCode}',
      );
    }
  }

  /// 日記のリストからGeminiに送るプロンプトを生成する
  String _createPrompt(List<DiaryEntry> diaries) {
    final goodDiaries = diaries
        .where((d) => d.category == DiaryCategory.good)
        .map((d) => '- ${d.content}')
        .join('\n');
    final badDiaries = diaries
        .where((d) => d.category == DiaryCategory.bad)
        .map((d) => '- ${d.content}')
        .join('\n');

    return '''
あなたは非常に優秀なキャリアコンサルタントです。
以下の情報を元に、就職活動や転職活動を行っているユーザーの自己分析を手伝ってください。

# ユーザー情報
- これから就職活動をする大学生、または転職を考えている社会人です。
- 仕事における自身の強み、弱み、そして効果的な自己PRの方法について知りたいと考えています。

# ユーザーが記録した日記
## 仕事の成果や楽しいと感じたこと
$goodDiaries

## 仕事で嫌だったこと
$badDiaries

# あなたへの依頼
上記の日記の内容を総合的に分析し、以下のフォーマットで回答を生成してください。

## 1. あなたの強み
（仕事の成果や楽しいと感じたことから推測される、ユーザーの強みを箇条書きで3つ挙げてください）

## 2. あなたの弱み・課題
（仕事で嫌だったことから推測される、ユーザーの弱みや今後の課題を箇条書きで2つ挙げてください）

## 3. 強みを活かす自己PRのヒント
（「1. あなたの強み」で挙げた内容を、具体的なエピソードを交えながらアピールするための例文やアドバイスを提供してください）
''';
  }
}

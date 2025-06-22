import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_career_app/presentation/provider/analysis_provider.dart';
import 'package:your_career_app/presentation/widget/primary_button.dart';

class AnalysisPage extends ConsumerWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(analysisResultProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('自己分析 by AI')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 分析結果表示エリア
            Expanded(
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: analysisState.when(
                    data: (result) {
                      if (result == null) {
                        return const Center(
                          child: Text(
                            '下部のボタンを押して\n自己分析を開始してください。',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }
                      // Markdown形式のテキストを表示
                      return Markdown(data: result);
                    },
                    loading:
                        () => const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('分析中です...'),
                            ],
                          ),
                        ),
                    error:
                        (err, stack) => Center(child: Text('エラーが発生しました: $err')),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 分析実行ボタン
            PrimaryButton(
              onPressed: () {
                ref.read(analysisResultProvider.notifier).executeAnalysis();
              },
              text: '分析を実行する',
              isLoading: analysisState.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

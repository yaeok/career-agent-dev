import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:your_career_app/domain/model/project_experience.dart';
import 'package:your_career_app/presentation/provider/project_experience_provider.dart';

class ResumePreviewPage extends ConsumerWidget {
  const ResumePreviewPage({super.key});

  /// 職務経歴のリストから整形されたテキストを生成する
  String _generateResumeText(List<ProjectExperience> experiences) {
    if (experiences.isEmpty) {
      return '職務経歴が登録されていません。';
    }

    final buffer = StringBuffer();
    final dateFormat = DateFormat('yyyy年MM月');

    buffer.writeln('【職務経歴】\n');

    for (final exp in experiences) {
      final startDate = dateFormat.format(exp.startDate);
      final endDate =
          exp.endDate != null ? dateFormat.format(exp.endDate!) : '現在';

      buffer.writeln('■ ${exp.projectName}');
      buffer.writeln('期間: $startDate 〜 $endDate');
      buffer.writeln('役割: ${exp.role}');
      buffer.writeln('\n概要・成果:');
      buffer.writeln(exp.description);

      if (exp.technologies.isNotEmpty) {
        buffer.writeln('\n使用技術:');
        buffer.writeln(exp.technologies.join(', '));
      }
      buffer.writeln('\n----------------------------------------\n');
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsState = ref.watch(projectExperiencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('職務経歴 プレビュー'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'クリップボードにコピー',
            onPressed: () {
              final textToCopy = projectsState.when(
                data: (projects) => _generateResumeText(projects),
                loading: () => '',
                error: (err, stack) => 'エラー: $err',
              );
              if (textToCopy.isNotEmpty) {
                Clipboard.setData(ClipboardData(text: textToCopy));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('クリップボードにコピーしました')),
                );
              }
            },
          ),
        ],
      ),
      body: projectsState.when(
        data: (projects) {
          final resumeText = _generateResumeText(projects);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: SelectableText(resumeText), // ユーザーがテキストを選択・コピーできるようにする
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('エラー: $err')),
      ),
    );
  }
}

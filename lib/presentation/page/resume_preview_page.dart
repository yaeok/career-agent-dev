import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:your_career_app/domain/model/analysis_result.dart';
import 'package:your_career_app/domain/model/project_experience.dart';
import 'package:your_career_app/presentation/provider/project_experience_provider.dart';
import 'package:your_career_app/presentation/provider/repository_provider.dart';

class ResumePreviewPage extends ConsumerWidget {
  const ResumePreviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsState = ref.watch(projectExperiencesProvider);
    final analysisResultState = ref.watch(analysisResultStreamProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('職務経歴 プレビュー'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'クリップボードにコピー',
            onPressed: () {
              if (projectsState.hasValue && analysisResultState.hasValue) {
                final textToCopy = _generateResumeText(
                  projectsState.value!,
                  analysisResultState.value,
                );
                if (textToCopy.isNotEmpty) {
                  Clipboard.setData(ClipboardData(text: textToCopy));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('クリップボードにコピーしました')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: projectsState.when(
        data: (projects) {
          return analysisResultState.when(
            data: (analysisResult) {
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  if (analysisResult != null) ...[
                    _buildSectionCard(
                      context: context,
                      icon: Icons.lightbulb_outline,
                      title: 'あなたの強み',
                      child: _buildChipList(context, analysisResult.strengths),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      context: context,
                      icon: Icons.task_outlined,
                      title: 'あなたの弱み・課題',
                      child: _buildChipList(context, analysisResult.weaknesses),
                    ),
                    const SizedBox(height: 16),
                  ],
                  _buildSectionCard(
                    context: context,
                    icon: Icons.work_outline,
                    title: '職務経歴',
                    child:
                        projects.isEmpty
                            ? const Text('職務経歴が登録されていません。')
                            : _buildProjectExperienceList(context, projects),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('分析結果の読み込みエラー: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('エラー: $err')),
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildChipList(BuildContext context, List<String> items) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children:
          items
              .map(
                (item) => Chip(
                  label: Text(item),
                  backgroundColor: theme.colorScheme.primaryContainer,
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                  side: BorderSide.none,
                ),
              )
              .toList(),
    );
  }

  Widget _buildProjectExperienceList(
    BuildContext context,
    List<ProjectExperience> experiences,
  ) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: experiences.length,
      separatorBuilder:
          (context, index) => const Divider(height: 32, thickness: 0.5),
      itemBuilder: (context, index) {
        final experience = experiences[index];
        return _buildProjectTimelineTile(context, experience);
      },
    );
  }

  Widget _buildProjectTimelineTile(
    BuildContext context,
    ProjectExperience experience,
  ) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy/MM');
    final dateRange =
        '${dateFormat.format(experience.startDate)} - ${experience.endDate != null ? dateFormat.format(experience.endDate!) : '現在'}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          experience.projectName,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$dateRange  |  ${experience.role}',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Text(
          experience.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        if (experience.technologies.isNotEmpty)
          _buildChipList(context, experience.technologies),
      ],
    );
  }

  String _generateResumeText(
    List<ProjectExperience> experiences,
    AnalysisResult? analysisResult,
  ) {
    final buffer = StringBuffer();
    final dateFormat = DateFormat('yyyy年MM月');

    if (analysisResult != null) {
      if (analysisResult.strengths.isNotEmpty) {
        buffer.writeln('【強み】');
        for (final strength in analysisResult.strengths) {
          buffer.writeln('・ $strength');
        }
        buffer.writeln();
      }
      if (analysisResult.weaknesses.isNotEmpty) {
        buffer.writeln('【弱み・課題】');
        for (final weakness in analysisResult.weaknesses) {
          buffer.writeln('・ $weakness');
        }
        buffer.writeln();
      }
    }

    buffer.writeln('【職務経歴】');
    if (experiences.isEmpty) {
      buffer.writeln('職務経歴が登録されていません。');
    } else {
      buffer.writeln();
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
    }
    return buffer.toString();
  }
}

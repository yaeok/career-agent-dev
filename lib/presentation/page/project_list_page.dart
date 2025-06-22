import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:your_career_app/presentation/provider/project_experience_provider.dart';
import 'package:your_career_app/presentation/widget/project_list_item.dart';

class ProjectListPage extends ConsumerWidget {
  const ProjectListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsState = ref.watch(projectExperiencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('職務経歴'),
        actions: [
          IconButton(
            icon: const Icon(Icons.preview_outlined),
            tooltip: 'プレビュー',
            onPressed: () {
              context.push('/resume-preview');
            },
          ),
        ],
      ),

      body: projectsState.when(
        data: (projects) {
          if (projects.isEmpty) {
            return const Center(
              child: Text('まだ職務経歴が登録されていません。', textAlign: TextAlign.center),
            );
          }
          return ListView.builder(
            itemCount: projects.length,
            itemBuilder:
                (context, index) =>
                    ProjectListItem(experience: projects[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('エラー: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/upsert-project'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

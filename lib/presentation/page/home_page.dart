import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:your_career_app/presentation/provider/auth_provider.dart';
import 'package:your_career_app/presentation/provider/diary_provider.dart';
import 'package:your_career_app/presentation/widget/diary_list_item.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diariesState = ref.watch(diariesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('マイダイアリー'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: '自己分析',
            onPressed: () {
              context.push('/analysis');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authUsecaseProvider).signOut();
            },
          ),
        ],
      ),
      body: diariesState.when(
        data: (diaries) {
          if (diaries.isEmpty) {
            return const Center(
              child: Text(
                'まだ日記がありません。\n右下のボタンから追加してみましょう！',
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
            itemCount: diaries.length,
            itemBuilder: (context, index) {
              return DiaryListItem(diary: diaries[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('エラーが発生しました: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 新規作成画面に遷移する
          context.push('/upsert-diary');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

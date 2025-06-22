import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:your_career_app/domain/model/diary_entry.dart';
import 'package:your_career_app/presentation/provider/diary_provider.dart';

class DiaryListItem extends ConsumerWidget {
  const DiaryListItem({super.key, required this.diary});

  final DiaryEntry diary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // カテゴリに応じたアイコンと色を決定
    final iconData =
        diary.category == DiaryCategory.good
            ? Icons.sentiment_very_satisfied
            : Icons.sentiment_very_dissatisfied;
    final color =
        diary.category == DiaryCategory.good
            ? Colors.blueAccent
            : Colors.redAccent;

    return Dismissible(
      key: ValueKey(diary.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) async {
        try {
          await ref.read(diaryUsecaseProvider).deleteDiary(diary.id!);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('日記を削除しました')));
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('削除に失敗しました: $e')));
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: Icon(iconData, color: color, size: 40),
          title: Text(
            diary.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            DateFormat('yyyy/MM/dd HH:mm').format(diary.createdAt),
          ),
          onTap: () {
            // 編集画面に遷移する（diaryオブジェクトを渡す）
            context.push('/upsert-diary', extra: diary);
          },
        ),
      ),
    );
  }
}

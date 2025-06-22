import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:your_career_app/domain/model/diary_entry.dart';
import 'package:your_career_app/presentation/provider/diary_provider.dart';
import 'package:your_career_app/presentation/widget/primary_button.dart';

class UpsertDiaryPage extends ConsumerStatefulWidget {
  const UpsertDiaryPage({super.key, this.diary});
  final DiaryEntry? diary; // 編集の場合は既存の日記データを受け取る

  @override
  ConsumerState<UpsertDiaryPage> createState() => _UpsertDiaryPageState();
}

class _UpsertDiaryPageState extends ConsumerState<UpsertDiaryPage> {
  late final TextEditingController _contentController;
  late DiaryCategory _selectedCategory;
  bool _isLoading = false;

  bool get _isEditing => widget.diary != null;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.diary?.content ?? '',
    );
    _selectedCategory = widget.diary?.category ?? DiaryCategory.good;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('内容を入力してください')));
      return;
    }
    setState(() => _isLoading = true);

    try {
      final usecase = ref.read(diaryUsecaseProvider);
      if (_isEditing) {
        // 更新処理
        final updatedDiary = widget.diary!.copyWith(
          content: _contentController.text,
          category: _selectedCategory,
        );
        await usecase.updateDiary(updatedDiary);
      } else {
        // 新規作成処理
        final newDiary = DiaryEntry(
          content: _contentController.text,
          category: _selectedCategory,
          createdAt: DateTime.now(),
        );
        await usecase.addDiary(newDiary);
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('日記を保存しました')));
        context.pop(); // 前の画面に戻る
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存に失敗しました: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? '日記を編集' : '新しい日記')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // カテゴリ選択
            SegmentedButton<DiaryCategory>(
              segments: const [
                ButtonSegment(
                  value: DiaryCategory.good,
                  label: Text('成果・楽しい'),
                  icon: Icon(Icons.sentiment_very_satisfied),
                ),
                ButtonSegment(
                  value: DiaryCategory.bad,
                  label: Text('嫌だったこと'),
                  icon: Icon(Icons.sentiment_very_dissatisfied),
                ),
              ],
              selected: {_selectedCategory},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _selectedCategory = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 16),
            // 内容入力
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null, // 複数行入力可能に
                expands: true, // 高さを親に合わせる
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: '今日あったことを記録しよう',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 保存ボタン
            PrimaryButton(
              onPressed: _onSave,
              text: '保存する',
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

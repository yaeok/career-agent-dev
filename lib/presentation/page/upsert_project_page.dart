import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:your_career_app/domain/model/project_experience.dart';
import 'package:your_career_app/presentation/provider/project_experience_provider.dart';
import 'package:your_career_app/presentation/widget/custom_text_form_field.dart';
import 'package:your_career_app/presentation/widget/primary_button.dart';

class UpsertProjectPage extends ConsumerStatefulWidget {
  const UpsertProjectPage({super.key, this.experience});
  final ProjectExperience? experience;

  @override
  ConsumerState<UpsertProjectPage> createState() => _UpsertProjectPageState();
}

class _UpsertProjectPageState extends ConsumerState<UpsertProjectPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _projectNameController;
  late final TextEditingController _roleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _technologiesController;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  bool get _isEditing => widget.experience != null;

  @override
  void initState() {
    super.initState();
    final p = widget.experience;
    _projectNameController = TextEditingController(text: p?.projectName);
    _roleController = TextEditingController(text: p?.role);
    _descriptionController = TextEditingController(text: p?.description);
    _technologiesController = TextEditingController(
      text: p?.technologies.join(', '),
    );
    _startDate = p?.startDate;
    _endDate = p?.endDate;
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _roleController.dispose();
    _descriptionController.dispose();
    _technologiesController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate() || _startDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('開始日を含む全ての必須項目を入力してください。')));
      return;
    }
    setState(() => _isLoading = true);

    try {
      final usecase = ref.read(projectExperienceUsecaseProvider);
      final technologies =
          _technologiesController.text
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();

      final newExperience = ProjectExperience(
        id: widget.experience?.id,
        projectName: _projectNameController.text,
        role: _roleController.text,
        startDate: _startDate!,
        endDate: _endDate,
        description: _descriptionController.text,
        technologies: technologies,
      );

      if (_isEditing) {
        await usecase.updateProjectExperience(newExperience);
      } else {
        await usecase.addProjectExperience(newExperience);
      }

      if (mounted) context.pop();
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存に失敗: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final now = DateTime.now();
    final initialDate = (isStartDate ? _startDate : _endDate) ?? now;
    final firstDate = DateTime(now.year - 20);
    final lastDate = DateTime(now.year + 20);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd');
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? '経歴を編集' : '経歴を追加')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                controller: _projectNameController,
                labelText: 'プロジェクト名 *',
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: _roleController,
                labelText: '役割・役職 *',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '開始日: ${_startDate != null ? dateFormat.format(_startDate!) : '未選択'} *',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context, true),
                    child: const Text('選択'),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '終了日: ${_endDate != null ? dateFormat.format(_endDate!) : '未選択'}',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context, false),
                    child: const Text('選択'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: _descriptionController,
                labelText: 'プロジェクト概要・成果 *',
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: _technologiesController,
                labelText: '使用技術 (カンマ区切り)',
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                onPressed: _onSave,
                text: '保存する',
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

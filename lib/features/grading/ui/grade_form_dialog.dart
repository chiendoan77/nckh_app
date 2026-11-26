import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_error.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/dialog_frame.dart';
import '../../../shared/widgets/form_dialog.dart';
import '../../../shared/widgets/state_views.dart';
import '../../topic/data/topic.dart';
import '../data/grade.dart';
import 'grade_providers.dart';

Future<void> showGradeFormDialog(BuildContext context, Topic topic) =>
    showDialog<void>(
      context: context,
      builder: (_) => _GradeFormDialog(topic: topic),
    );

class _GradeFormDialog extends ConsumerWidget {
  const _GradeFormDialog({required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grade = ref.watch(gradeProvider(topic.id));
    return grade.when(
      loading: () => DialogFrame(
        title: topic.title,
        actions: const [],
        child: const LoadingView(),
      ),
      error: (error, _) => DialogFrame(
        title: topic.title,
        actions: [
          AppButton(
            label: 'Đóng',
            kind: AppButtonKind.ghost,
            onPressed: () => Navigator.pop(context),
          ),
        ],
        child: ErrorView(
          message: error is ApiError ? error.message : '$error',
          onRetry: () => ref.invalidate(gradeProvider(topic.id)),
        ),
      ),
      data: (value) => _GradeForm(topic: topic, grade: value),
    );
  }
}

class _GradeForm extends ConsumerStatefulWidget {
  const _GradeForm({required this.topic, required this.grade});

  final Topic topic;
  final Grade? grade;

  @override
  ConsumerState<_GradeForm> createState() => _GradeFormState();
}

class _GradeFormState extends ConsumerState<_GradeForm> {
  late final _scoreController = TextEditingController(
    text: widget.grade?.average.toString() ?? '',
  );
  late final _commentController = TextEditingController(
    text: widget.grade?.comment ?? '',
  );

  @override
  void dispose() {
    _scoreController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final average = double.tryParse(_scoreController.text.trim());
    if (average == null) {
      return;
    }
    final scores = [
      for (
        var index = 0;
        index < widget.topic.memberNames.length &&
            index < widget.topic.memberIds.length;
        index++
      )
        MemberScore(
          name: widget.topic.memberNames[index],
          studentId: widget.topic.memberIds[index],
          score: average,
        ),
    ];
    final grade = Grade(
      topicId: widget.topic.id,
      topicTitle: widget.topic.title,
      average: average,
      reportTerm: widget.grade?.reportTerm ?? _currentTerm(),
      comment: _commentController.text.trim(),
      scores: scores.isEmpty ? widget.grade?.scores ?? const [] : scores,
    );
    final repository = ref.read(gradeRepositoryProvider);
    if (widget.grade == null) {
      await repository.create(grade);
    } else {
      await repository.update(widget.topic.id, grade);
    }
    for (final studentId in widget.topic.memberIds) {
      ref.invalidate(gradesProvider(studentId));
    }
    if (mounted) {
      AppToast.success(context, 'Lưu điểm thành công.');
    }
  }

  String _currentTerm() {
    final year = DateTime.now().year;
    return '$year–${year + 1}';
  }

  @override
  Widget build(BuildContext context) => FormDialog(
    title: widget.grade == null ? 'Chấm điểm đề tài' : 'Cập nhật điểm',
    onSubmit: _save,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          key: const Key('grade-score'),
          controller: _scoreController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Điểm trung bình'),
          validator: validateScore,
        ),
        const SizedBox(height: 16),
        TextFormField(
          key: const Key('grade-comment'),
          controller: _commentController,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(labelText: 'Nhận xét'),
          validator: validateRequired,
        ),
      ],
    ),
  );
}

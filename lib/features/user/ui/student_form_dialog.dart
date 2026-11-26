import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/form_dialog.dart';
import '../data/student.dart';
import 'user_providers.dart';

Future<void> showStudentFormDialog(
  BuildContext context,
  WidgetRef ref,
  Student student,
) => showDialog<void>(
  context: context,
  builder: (_) => StudentFormDialog(student: student),
);

class StudentFormDialog extends ConsumerStatefulWidget {
  const StudentFormDialog({super.key, required this.student});

  final Student student;

  @override
  ConsumerState<StudentFormDialog> createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends ConsumerState<StudentFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _majorController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.fullName);
    _majorController = TextEditingController(text: widget.student.major);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final student = widget.student;
    await ref
        .read(studentRepositoryProvider)
        .update(
          Student(
            id: student.id,
            fullName: _nameController.text.trim(),
            birthDate: student.birthDate,
            major: _majorController.text.trim(),
            gpa: student.gpa,
            status: student.status,
          ),
        );
    if (!mounted) {
      return;
    }
    ref.invalidate(studentProvider(student.id));
    AppToast.success(context, 'Cập nhật hồ sơ thành công.');
  }

  @override
  Widget build(BuildContext context) => FormDialog(
    title: 'Chỉnh sửa hồ sơ',
    onSubmit: _submit,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Họ tên'),
          validator: validateRequired,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _majorController,
          decoration: const InputDecoration(labelText: 'Chuyên ngành'),
          validator: validateRequired,
        ),
      ],
    ),
  );
}

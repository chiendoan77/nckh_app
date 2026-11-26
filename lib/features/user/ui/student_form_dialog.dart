import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/validators.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_button.dart';
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

Future<void> showStudentAdminDialog(
  BuildContext context,
  WidgetRef ref, {
  Student? student,
  bool readOnly = false,
}) => showDialog<void>(
  context: context,
  builder: (_) => _StudentAdminDialog(student: student, readOnly: readOnly),
);

class _StudentAdminDialog extends ConsumerStatefulWidget {
  const _StudentAdminDialog({this.student, required this.readOnly});

  final Student? student;
  final bool readOnly;

  @override
  ConsumerState<_StudentAdminDialog> createState() =>
      _StudentAdminDialogState();
}

class _StudentAdminDialogState extends ConsumerState<_StudentAdminDialog> {
  late final _idController = TextEditingController(
    text: widget.student?.id ?? '',
  );
  late final _nameController = TextEditingController(
    text: widget.student?.fullName ?? '',
  );
  late final _majorController = TextEditingController(
    text: widget.student?.major ?? '',
  );
  late final _gpaController = TextEditingController(
    text: widget.student?.gpa.toString() ?? '',
  );
  late StudentStatus _status = widget.student?.status ?? StudentStatus.active;

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _majorController.dispose();
    _gpaController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final student = Student(
      id: _idController.text.trim(),
      fullName: _nameController.text.trim(),
      birthDate: widget.student?.birthDate,
      major: _majorController.text.trim(),
      gpa: double.parse(_gpaController.text.trim()),
      status: _status,
    );
    final repository = ref.read(studentRepositoryProvider);
    if (widget.student == null) {
      await repository.create(student);
    } else {
      await repository.update(student);
    }
    ref.invalidate(studentsProvider);
    if (student.id == widget.student?.id) {
      ref.invalidate(studentProvider(student.id));
    }
    if (mounted) {
      AppToast.success(
        context,
        widget.student == null
            ? 'Thêm sinh viên thành công.'
            : 'Cập nhật sinh viên thành công.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.readOnly && widget.student != null) {
      final student = widget.student!;
      return AlertDialog(
        title: const Text('Thông tin sinh viên'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mã sinh viên: ${student.id}'),
            Text('Họ tên: ${student.fullName}'),
            Text('Chuyên ngành: ${student.major}'),
            Text('GPA: ${formatGpa(student.gpa)}'),
            Text('Trạng thái: ${student.status.label}'),
          ],
        ),
        actions: [
          AppButton(
            label: 'Đóng',
            kind: AppButtonKind.ghost,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    }

    return FormDialog(
      title: widget.student == null ? 'Thêm sinh viên' : 'Sửa sinh viên',
      onSubmit: _save,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            key: const Key('student-id'),
            controller: _idController,
            readOnly: widget.student != null,
            decoration: const InputDecoration(labelText: 'Mã sinh viên'),
            validator: validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const Key('student-name'),
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Họ tên'),
            validator: validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const Key('student-major'),
            controller: _majorController,
            decoration: const InputDecoration(labelText: 'Chuyên ngành'),
            validator: validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const Key('student-gpa'),
            controller: _gpaController,
            readOnly: widget.student != null,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'GPA'),
            validator: _validateGpa,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<StudentStatus>(
            key: const Key('student-status'),
            initialValue: _status,
            decoration: const InputDecoration(labelText: 'Trạng thái'),
            items: [
              for (final status in StudentStatus.values)
                DropdownMenuItem(value: status, child: Text(status.label)),
            ],
            onChanged: (status) {
              if (status != null) {
                setState(() => _status = status);
              }
            },
          ),
        ],
      ),
    );
  }
}

String? _validateGpa(String? value) {
  final gpa = double.tryParse(value?.trim() ?? '');
  if (gpa == null || gpa < 0 || gpa > 4) {
    return 'GPA phải từ 0 đến 4.';
  }
  return null;
}

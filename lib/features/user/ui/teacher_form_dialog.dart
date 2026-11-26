import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/user_role.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/form_dialog.dart';
import '../data/teacher.dart';
import 'user_providers.dart';

Future<void> showTeacherFormDialog(
  BuildContext context,
  WidgetRef ref, {
  Teacher? teacher,
  bool readOnly = false,
}) {
  if (readOnly && teacher != null) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Thông tin giảng viên'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mã giảng viên: ${teacher.id}'),
            Text('Họ tên: ${teacher.fullName}'),
            Text('Khoa: ${teacher.faculty}'),
            Text('Học vị: ${teacher.degree}'),
            Text('Email: ${teacher.email}'),
            Text(
              'Chức vụ: ${teacher.positions.map((role) => role.label).join(' · ')}',
            ),
          ],
        ),
        actions: [
          AppButton(
            label: 'Đóng',
            kind: AppButtonKind.ghost,
            onPressed: () => Navigator.pop(dialogContext),
          ),
        ],
      ),
    );
  }
  return showDialog<void>(
    context: context,
    builder: (_) => _TeacherFormDialog(teacher: teacher),
  );
}

class _TeacherFormDialog extends ConsumerStatefulWidget {
  const _TeacherFormDialog({this.teacher});

  final Teacher? teacher;

  @override
  ConsumerState<_TeacherFormDialog> createState() => _TeacherFormDialogState();
}

class _TeacherFormDialogState extends ConsumerState<_TeacherFormDialog> {
  late final _idController = TextEditingController(
    text: widget.teacher?.id ?? '',
  );
  late final _nameController = TextEditingController(
    text: widget.teacher?.fullName ?? '',
  );
  late final _degreeController = TextEditingController(
    text: widget.teacher?.degree ?? '',
  );
  late final _facultyController = TextEditingController(
    text: widget.teacher?.faculty ?? '',
  );
  late final _emailController = TextEditingController(
    text: widget.teacher?.email ?? '',
  );
  late List<UserRole> _positions = [...?widget.teacher?.positions];

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _degreeController.dispose();
    _facultyController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final teacher = Teacher(
      id: _idController.text.trim(),
      fullName: _nameController.text.trim(),
      degree: _degreeController.text.trim(),
      faculty: _facultyController.text.trim(),
      email: _emailController.text.trim(),
      positions: _positions,
    );
    final repository = ref.read(teacherRepositoryProvider);
    if (widget.teacher == null) {
      await repository.create(teacher);
    } else {
      await repository.update(teacher);
    }
    ref.invalidate(teachersProvider);
    if (mounted) {
      AppToast.success(
        context,
        widget.teacher == null
            ? 'Thêm giảng viên thành công.'
            : 'Cập nhật giảng viên thành công.',
      );
    }
  }

  @override
  Widget build(BuildContext context) => FormDialog(
    title: widget.teacher == null ? 'Thêm giảng viên' : 'Sửa giảng viên',
    onSubmit: _save,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          key: const Key('teacher-id'),
          controller: _idController,
          readOnly: widget.teacher != null,
          decoration: const InputDecoration(labelText: 'Mã giảng viên'),
          validator: validateRequired,
        ),
        const SizedBox(height: 12),
        TextFormField(
          key: const Key('teacher-name'),
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Họ tên'),
          validator: validateRequired,
        ),
        const SizedBox(height: 12),
        TextFormField(
          key: const Key('teacher-faculty'),
          controller: _facultyController,
          decoration: const InputDecoration(labelText: 'Khoa'),
          validator: validateRequired,
        ),
        const SizedBox(height: 12),
        TextFormField(
          key: const Key('teacher-degree'),
          controller: _degreeController,
          decoration: const InputDecoration(labelText: 'Học vị'),
          validator: validateRequired,
        ),
        const SizedBox(height: 12),
        TextFormField(
          key: const Key('teacher-email'),
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Email'),
          validator: validateRequired,
        ),
        const SizedBox(height: 12),
        FormField<List<UserRole>>(
          initialValue: _positions,
          validator: (roles) => roles == null || roles.isEmpty
              ? 'Chọn ít nhất một chức vụ.'
              : null,
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckboxListTile(
                key: const Key('teacher-role-manager'),
                contentPadding: EdgeInsets.zero,
                title: const Text('Quản lý'),
                value: field.value?.contains(UserRole.manager) ?? false,
                onChanged: (selected) =>
                    _toggleRole(field, UserRole.manager, selected ?? false),
              ),
              CheckboxListTile(
                key: const Key('teacher-role-teacher'),
                contentPadding: EdgeInsets.zero,
                title: const Text('Giảng viên'),
                value: field.value?.contains(UserRole.teacher) ?? false,
                onChanged: (selected) =>
                    _toggleRole(field, UserRole.teacher, selected ?? false),
              ),
              if (field.errorText != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    field.errorText!,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );

  void _toggleRole(
    FormFieldState<List<UserRole>> field,
    UserRole role,
    bool selected,
  ) {
    final positions = [...?field.value];
    if (selected && !positions.contains(role)) {
      positions.add(role);
    } else if (!selected) {
      positions.remove(role);
    }
    _positions = positions;
    field.didChange(positions);
  }
}

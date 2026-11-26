import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_error.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../data/student.dart';
import 'student_form_dialog.dart';
import 'user_providers.dart';

class ProfilePanel extends ConsumerWidget {
  const ProfilePanel({super.key, required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(studentProvider(studentId));
    return Padding(
      padding: const EdgeInsets.all(24),
      child: student.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: error is ApiError
              ? error.message
              : 'Không tải được hồ sơ sinh viên.',
          onRetry: () => ref.invalidate(studentProvider(studentId)),
        ),
        data: (value) => value == null
            ? const EmptyView('Chưa có thông tin hồ sơ sinh viên.')
            : _StudentProfile(student: value),
      ),
    );
  }
}

class _StudentProfile extends ConsumerWidget {
  const _StudentProfile({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context, WidgetRef ref) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hồ sơ sinh viên', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 24),
        _ProfileField(label: 'Mã sinh viên', value: student.id),
        _ProfileField(label: 'Họ tên', value: student.fullName),
        _ProfileField(
          label: 'Ngày sinh',
          value: student.birthDate == null
              ? 'Chưa cập nhật'
              : formatDate(student.birthDate!),
        ),
        _ProfileField(label: 'Chuyên ngành', value: student.major),
        _ProfileField(label: 'GPA', value: formatGpa(student.gpa)),
        const SizedBox(height: 24),
        AppButton(
          label: 'Chỉnh sửa',
          onPressed: () => showStudentFormDialog(context, ref, student),
        ),
      ],
    ),
  );
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ],
    ),
  );
}

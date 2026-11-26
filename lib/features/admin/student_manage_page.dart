import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_tokens.dart';
import '../../core/network/api_error.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/paging.dart';
import '../../features/user/data/student.dart';
import '../../features/user/ui/student_form_dialog.dart';
import '../../features/user/ui/user_providers.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/list_row.dart';
import '../../shared/widgets/pager_bar.dart';
import '../../shared/widgets/state_views.dart';

class StudentManagePage extends ConsumerStatefulWidget {
  const StudentManagePage({super.key});

  @override
  ConsumerState<StudentManagePage> createState() => _StudentManagePageState();
}

class _StudentManagePageState extends ConsumerState<StudentManagePage> {
  int _page = 1;

  Future<void> _delete(Student student) async {
    final confirmed = await showConfirmDialog(
      context,
      'Bạn có chắc muốn xóa sinh viên ${student.fullName}?',
      danger: true,
    );
    if (!confirmed || !mounted) {
      return;
    }
    try {
      await ref.read(studentRepositoryProvider).delete(student.id);
      ref.invalidate(studentsProvider);
      setState(() => _page = 1);
      if (mounted) {
        AppToast.success(context, 'Xóa sinh viên thành công.');
      }
    } on ApiError catch (error) {
      if (mounted) {
        AppToast.error(context, error.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final students = ref.watch(studentsProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: students.when(
                  loading: () => const Text('Đang tải sinh viên…'),
                  error: (_, _) => const Text('Chưa tải được số liệu'),
                  data: (items) => Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      Text('Tổng: ${items.length}'),
                      Text(
                        'Hoạt động: ${items.where((student) => student.status == StudentStatus.active).length}',
                      ),
                      Text(
                        'Đình chỉ: ${items.where((student) => student.status == StudentStatus.suspended).length}',
                      ),
                    ],
                  ),
                ),
              ),
              AppButton(
                label: '+ Thêm sinh viên',
                onPressed: () async {
                  await showStudentAdminDialog(context, ref);
                  if (mounted) {
                    setState(() => _page = 1);
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: students.when(
            loading: () => const LoadingView(),
            error: (error, _) => ErrorView(
              message: error is ApiError ? error.message : '$error',
              onRetry: () => ref.invalidate(studentsProvider),
            ),
            data: (items) => items.isEmpty
                ? const EmptyView('Chưa có sinh viên.')
                : _studentTable(items),
          ),
        ),
      ],
    );
  }

  Widget _studentTable(List<Student> students) {
    final pageCount = (students.length / pageSize).ceil();
    final currentPage = _page > pageCount ? pageCount : _page;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 1000,
                child: Column(
                  children: [
                    _studentHeader(context),
                    for (final student in pageOf(students, currentPage))
                      ListRow(
                        key: ValueKey('student-row-${student.id}'),
                        cells: [
                          Text(student.id),
                          Text(student.fullName),
                          Text(student.major),
                          Text(formatGpa(student.gpa)),
                          Text(student.status.label),
                        ],
                        onView: () => showStudentAdminDialog(
                          context,
                          ref,
                          student: student,
                          readOnly: true,
                        ),
                        onEdit: () => showStudentAdminDialog(
                          context,
                          ref,
                          student: student,
                        ),
                        onDelete: () => _delete(student),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: PagerBar(
            total: students.length,
            page: currentPage,
            onChanged: (page) => setState(() => _page = page),
          ),
        ),
      ],
    );
  }

  Widget _studentHeader(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 48),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppTokens.border)),
    ),
    child: Row(
      children: [
        for (final label in const [
          'Mã sinh viên',
          'Họ tên',
          'Chuyên ngành',
          'GPA',
          'Trạng thái',
        ])
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        const Expanded(flex: 3, child: SizedBox.shrink()),
      ],
    ),
  );
}

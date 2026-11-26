import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_tokens.dart';
import '../../core/constants/user_role.dart';
import '../../core/network/api_error.dart';
import '../../core/utils/paging.dart';
import '../../features/user/data/teacher.dart';
import '../../features/user/ui/teacher_form_dialog.dart';
import '../../features/user/ui/user_providers.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/list_row.dart';
import '../../shared/widgets/pager_bar.dart';
import '../../shared/widgets/state_views.dart';

class TeacherManagePage extends ConsumerWidget {
  const TeacherManagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teachers = ref.watch(teachersProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Quản lý giảng viên',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              AppButton(
                key: const Key('add-teacher'),
                label: '+ Thêm giảng viên',
                onPressed: () => showTeacherFormDialog(context, ref),
              ),
            ],
          ),
        ),
        Expanded(
          child: teachers.when(
            loading: () => const LoadingView(),
            error: (error, _) => ErrorView(
              message: error is ApiError ? error.message : '$error',
              onRetry: () => ref.invalidate(teachersProvider),
            ),
            data: (items) => items.isEmpty
                ? const EmptyView('Chưa có giảng viên.')
                : DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        const TabBar(
                          tabs: [
                            Tab(text: 'Giảng viên'),
                            Tab(text: 'Quản lý'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _TeacherTable(
                                teachers: items,
                                role: UserRole.teacher,
                              ),
                              _TeacherTable(
                                teachers: items,
                                role: UserRole.manager,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class _TeacherTable extends ConsumerStatefulWidget {
  const _TeacherTable({required this.teachers, required this.role});

  final List<Teacher> teachers;
  final UserRole role;

  @override
  ConsumerState<_TeacherTable> createState() => _TeacherTableState();
}

class _TeacherTableState extends ConsumerState<_TeacherTable> {
  int _page = 1;

  Future<void> _delete(Teacher teacher) async {
    final confirmed = await showConfirmDialog(
      context,
      'Bạn có chắc muốn xóa giảng viên ${teacher.fullName}?',
      danger: true,
    );
    if (!confirmed || !mounted) {
      return;
    }
    try {
      await ref.read(teacherRepositoryProvider).delete(teacher.id);
      ref.invalidate(teachersProvider);
      setState(() => _page = 1);
      if (mounted) {
        AppToast.success(context, 'Xóa giảng viên thành công.');
      }
    } on ApiError catch (error) {
      if (mounted) {
        AppToast.error(context, error.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final teachers = widget.teachers
        .where((teacher) => teacher.positions.contains(widget.role))
        .toList();
    final pageCount = (teachers.length / pageSize).ceil();
    final currentPage = _page > pageCount && pageCount > 0 ? pageCount : _page;
    if (teachers.isEmpty) {
      return const EmptyView('Chưa có dữ liệu phù hợp.');
    }
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
                    _teacherHeader(context),
                    for (final teacher in pageOf(teachers, currentPage))
                      ListRow(
                        key: ValueKey('teacher-row-${teacher.id}'),
                        cells: [
                          Text(teacher.id),
                          Text(teacher.degree),
                          Text(teacher.faculty),
                          Text(teacher.email),
                        ],
                        onView: () => showTeacherFormDialog(
                          context,
                          ref,
                          teacher: teacher,
                          readOnly: true,
                        ),
                        onEdit: () => showTeacherFormDialog(
                          context,
                          ref,
                          teacher: teacher,
                        ),
                        onDelete: () => _delete(teacher),
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
            total: teachers.length,
            page: currentPage,
            onChanged: (page) => setState(() => _page = page),
          ),
        ),
      ],
    );
  }

  Widget _teacherHeader(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 48),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppTokens.border)),
    ),
    child: Row(
      children: [
        for (final label in const ['Mã giảng viên', 'Học vị', 'Khoa', 'Email'])
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

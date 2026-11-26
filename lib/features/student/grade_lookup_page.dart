import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/session.dart';
import '../../core/network/api_error.dart';
import '../../core/utils/formatters.dart';
import '../../features/grading/data/grade.dart';
import '../../features/grading/ui/grade_detail_dialog.dart';
import '../../features/grading/ui/grade_providers.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/card_grid.dart';
import '../../shared/widgets/search_field.dart';
import '../../shared/widgets/state_views.dart';

class GradeLookupPage extends ConsumerWidget {
  const GradeLookupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentId = ref.watch(sessionProvider)?.user.studentId;
    if (studentId == null) {
      return const EmptyView(
        'Không tìm thấy mã sinh viên trong phiên đăng nhập.',
      );
    }

    final grades = ref.watch(visibleGradesProvider(studentId));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SearchField(
            hint: 'Tìm đề tài đã chấm…',
            onChanged: (value) =>
                ref.read(gradeSearchProvider.notifier).state = value,
          ),
        ),
        Expanded(
          child: grades.when(
            loading: () => const LoadingView(),
            error: (error, _) => ErrorView(
              message: error is ApiError
                  ? error.message
                  : 'Không tải được bảng điểm.',
              onRetry: () => ref.invalidate(gradesProvider(studentId)),
            ),
            data: (items) => items.isEmpty
                ? const EmptyView('Chưa có đề tài được chấm điểm.')
                : CardGrid<Grade>(
                    items: items,
                    itemBuilder: (_, grade) => AppCard(
                      onTap: () => showGradeDetailDialog(context, grade),
                      footer: Text('Kỳ báo cáo: ${grade.reportTerm}'),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              grade.topicTitle,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            formatGpa(grade.average),
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

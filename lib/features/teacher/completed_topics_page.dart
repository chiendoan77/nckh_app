import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/session.dart';
import '../../core/constants/topic_status.dart';
import '../../core/network/api_error.dart';
import '../../core/utils/formatters.dart';
import '../grading/ui/grade_form_dialog.dart';
import '../topic/ui/topic_card.dart';
import '../topic/ui/topic_providers.dart';
import '../../shared/widgets/card_grid.dart';
import '../../shared/widgets/state_views.dart';

class CompletedTopicsPage extends ConsumerWidget {
  const CompletedTopicsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(topicsProvider);
    final teacherId = ref.watch(sessionProvider)?.user.teacherId;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Đề tài đã hoàn thành',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        Expanded(
          child: topics.when(
            loading: () => const LoadingView(),
            error: (error, _) => ErrorView(
              message: error is ApiError ? error.message : '$error',
              onRetry: () => ref.invalidate(topicsProvider),
            ),
            data: (items) {
              final completed = items
                  .where(
                    (topic) =>
                        teacherId != null &&
                        topic.supervisor?.id == teacherId &&
                        topic.status == TopicStatus.completed,
                  )
                  .toList();
              if (completed.isEmpty) {
                return const EmptyView('Chưa có đề tài đã hoàn thành.');
              }
              return CardGrid(
                items: completed,
                itemBuilder: (_, topic) {
                  Future<void> showForm() =>
                      showGradeFormDialog(context, topic);
                  final deadline = topic.gradingDeadline == null
                      ? 'Hạn chấm: Chưa có hạn'
                      : 'Hạn chấm: ${formatDate(topic.gradingDeadline!)}';
                  return TopicCard(
                    topic: topic,
                    onView: showForm,
                    onTap: showForm,
                    viewLabel: 'Chấm điểm',
                    detailLine: deadline,
                    showAuthor: false,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

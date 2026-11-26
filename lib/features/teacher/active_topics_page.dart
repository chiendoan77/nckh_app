import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/session.dart';
import '../../core/constants/topic_status.dart';
import '../../core/network/api_error.dart';
import '../topic/ui/teacher_detail_dialog.dart';
import '../topic/ui/topic_card.dart';
import '../topic/ui/topic_providers.dart';
import '../../shared/widgets/card_grid.dart';
import '../../shared/widgets/state_views.dart';

class ActiveTopicsPage extends ConsumerWidget {
  const ActiveTopicsPage({super.key});

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
              'Công việc',
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
              final assigned = items
                  .where(
                    (topic) =>
                        teacherId != null &&
                        topic.supervisor?.id == teacherId &&
                        (topic.status == TopicStatus.inProgress ||
                            topic.status == TopicStatus.extended),
                  )
                  .toList();
              if (assigned.isEmpty) {
                return const EmptyView('Chưa có đề tài đang hướng dẫn.');
              }
              return CardGrid(
                items: assigned,
                itemBuilder: (_, topic) {
                  Future<void> showDetail() =>
                      showTeacherDialog(context, topic);
                  return TopicCard(
                    topic: topic,
                    onView: showDetail,
                    onTap: showDetail,
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

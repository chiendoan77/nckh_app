import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/topic_status.dart';
import '../../core/network/api_error.dart';
import '../../features/topic/data/topic.dart';
import '../../features/topic/ui/cancel_topic_dialog.dart';
import '../../features/topic/ui/extend_topic_dialog.dart';
import '../../features/topic/ui/topic_card.dart';
import '../../features/topic/ui/topic_detail_dialog.dart';
import '../../features/topic/ui/topic_providers.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/card_grid.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/search_field.dart';
import '../../shared/widgets/state_views.dart';

class TopicReviewPage extends ConsumerWidget {
  const TopicReviewPage({super.key});

  Future<void> _approve(
    BuildContext context,
    WidgetRef ref,
    Topic topic,
  ) async {
    try {
      await ref.read(topicRepositoryProvider).approve(topic.id);
      if (!context.mounted) {
        return;
      }
      ref.invalidate(topicsProvider);
      AppToast.success(context, 'Phê duyệt đề tài thành công.');
    } on ApiError catch (error) {
      if (context.mounted) {
        AppToast.error(context, error.message);
      }
    }
  }

  Future<void> _cancel(BuildContext context, WidgetRef ref, Topic topic) async {
    final reason = await showCancelTopicDialog(context);
    if (!context.mounted || reason == null) {
      return;
    }
    final confirmed = await showConfirmDialog(
      context,
      'Bạn có chắc chắn muốn hủy đề tài này?',
      danger: true,
    );
    if (!context.mounted || !confirmed) {
      return;
    }
    try {
      await ref.read(topicRepositoryProvider).cancel(topic.id, reason: reason);
      if (!context.mounted) {
        return;
      }
      ref.invalidate(topicsProvider);
      AppToast.success(context, 'Hủy đề tài thành công.');
    } on ApiError catch (error) {
      if (context.mounted) {
        AppToast.error(context, error.message);
      }
    }
  }

  Future<void> _extend(BuildContext context, WidgetRef ref, Topic topic) async {
    final deadline = await showExtendTopicDialog(context, topic);
    if (!context.mounted || deadline == null) {
      return;
    }
    try {
      await ref
          .read(topicRepositoryProvider)
          .extend(topic.id, newDeadline: deadline);
      if (!context.mounted) {
        return;
      }
      ref.invalidate(topicsProvider);
      AppToast.success(context, 'Gia hạn đề tài thành công.');
    } on ApiError catch (error) {
      if (context.mounted) {
        AppToast.error(context, error.message);
      }
    }
  }

  void _performAction(
    BuildContext context,
    WidgetRef ref,
    Topic topic,
    TopicAction action,
  ) {
    switch (action) {
      case TopicAction.approve:
        _approve(context, ref, topic);
      case TopicAction.cancel:
        _cancel(context, ref, topic);
      case TopicAction.extend:
        _extend(context, ref, topic);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(topicsProvider);
    final keyword = ref.watch(topicSearchProvider).trim().toLowerCase();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SearchField(
            hint: 'Tìm đề tài…',
            onChanged: (value) =>
                ref.read(topicSearchProvider.notifier).state = value,
          ),
        ),
        Expanded(
          child: topics.when(
            loading: () => const LoadingView(),
            error: (error, _) => ErrorView(
              message: error is ApiError
                  ? error.message
                  : 'Không tải được danh sách đề tài.',
              onRetry: () => ref.invalidate(topicsProvider),
            ),
            data: (items) {
              final visibleTopics = items
                  .where((topic) => topic.title.toLowerCase().contains(keyword))
                  .toList();
              if (visibleTopics.isEmpty) {
                return const EmptyView('Chưa có đề tài phù hợp.');
              }
              return CardGrid<Topic>(
                items: visibleTopics,
                itemBuilder: (_, topic) => TopicCard(
                  topic: topic,
                  onView: () => showTopicDetailDialog(
                    context,
                    topic,
                    buttons: [
                      for (final action
                          in allowedActions[topic.status] ?? const [])
                        DialogButton(
                          _labelOf(action),
                          () => _performAction(context, ref, topic, action),
                          kind: action == TopicAction.cancel
                              ? AppButtonKind.danger
                              : AppButtonKind.primary,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _labelOf(TopicAction action) => switch (action) {
    TopicAction.approve => 'PHÊ DUYỆT',
    TopicAction.cancel => 'HỦY ĐỀ TÀI',
    TopicAction.extend => 'GIA HẠN',
  };
}

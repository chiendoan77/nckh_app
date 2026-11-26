import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/topic_status.dart';
import '../../core/network/api_error.dart';
import '../../features/topic/data/topic.dart';
import '../../features/topic/ui/topic_card.dart';
import '../../features/topic/ui/topic_detail_dialog.dart';
import '../../features/topic/ui/topic_form_dialog.dart';
import '../../features/topic/ui/topic_providers.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/card_grid.dart';
import '../../shared/widgets/state_views.dart';
import '../../shared/widgets/search_field.dart';

class TopicRegisterPage extends ConsumerWidget {
  const TopicRegisterPage({super.key});

  Future<void> _register(
    BuildContext context,
    WidgetRef ref,
    Topic topic,
  ) async {
    try {
      await ref.read(topicRepositoryProvider).register(topic.id);
      if (!context.mounted) {
        return;
      }
      ref.invalidate(topicsProvider);
      AppToast.success(context, 'Đăng ký thành công.');
    } on ApiError catch (error) {
      if (context.mounted) {
        AppToast.error(context, error.message);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(visibleTopicsProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final searchField = SearchField(
                hint: 'Tìm đề tài…',
                onChanged: (value) =>
                    ref.read(topicSearchProvider.notifier).state = value,
              );
              final proposeButton = AppButton(
                label: '+ Đề xuất đề tài',
                onPressed: () => showTopicFormDialog(context, ref),
              );
              if (constraints.maxWidth < 760) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    searchField,
                    const SizedBox(height: 12),
                    proposeButton,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: searchField),
                  const SizedBox(width: 12),
                  proposeButton,
                ],
              );
            },
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
            data: (items) => items.isEmpty
                ? const EmptyView('Chưa có đề tài.')
                : CardGrid<Topic>(
                    items: items,
                    itemBuilder: (_, topic) => TopicCard(
                      topic: topic,
                      onView: () => showTopicDetailDialog(
                        context,
                        topic,
                        buttons: topic.status == TopicStatus.approved
                            ? [
                                DialogButton(
                                  'Đăng ký',
                                  () => _register(context, ref, topic),
                                ),
                              ]
                            : const [],
                      ),
                      onEdit:
                          topic.isMine && topic.status == TopicStatus.pending
                          ? () =>
                                showTopicFormDialog(context, ref, topic: topic)
                          : null,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

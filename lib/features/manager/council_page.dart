import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/council/ui/council_card.dart';
import '../../features/council/ui/council_detail_dialog.dart';
import '../../features/council/ui/council_form_dialog.dart';
import '../../features/council/ui/council_providers.dart';
import '../../features/topic/ui/topic_providers.dart';
import '../../features/user/ui/user_providers.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/state_views.dart';

class CouncilPage extends ConsumerWidget {
  const CouncilPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final councils = ref.watch(councilsProvider);
    final teachers = ref.watch(teachersProvider);
    final topics = ref.watch(topicsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Hội đồng chấm',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              AppButton(
                label: '+ Thêm nhóm',
                onPressed: () => showCouncilFormDialog(
                  context,
                  onSubmit: (name, type, createdOn) async {
                    await ref
                        .read(councilRepositoryProvider)
                        .create(name: name, type: type, createdOn: createdOn);
                    ref.invalidate(councilsProvider);
                    if (context.mounted) {
                      AppToast.success(context, 'Tạo hội đồng thành công.');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: councils.when(
            loading: () => const LoadingView(),
            error: (error, _) => ErrorView(
              message: '$error',
              onRetry: () => ref.invalidate(councilsProvider),
            ),
            data: (items) {
              if (items.isEmpty) {
                return const EmptyView('Chưa có hội đồng chấm.');
              }
              return teachers.when(
                loading: () => const LoadingView(),
                error: (error, _) => ErrorView(
                  message: '$error',
                  onRetry: () => ref.invalidate(teachersProvider),
                ),
                data: (teacherItems) => topics.when(
                  loading: () => const LoadingView(),
                  error: (error, _) => ErrorView(
                    message: '$error',
                    onRetry: () => ref.invalidate(topicsProvider),
                  ),
                  data: (topicItems) => ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final council = items[index];
                      return CouncilCard(
                        council: council,
                        onTap: () => showCouncilDetailDialog(
                          context,
                          council: council,
                          teachers: teacherItems,
                          topics: topicItems,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

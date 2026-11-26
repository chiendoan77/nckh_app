import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/core/constants/topic_status.dart';
import 'package:nckh_app/features/topic/data/mock_topic_repository.dart';
import 'package:nckh_app/features/topic/ui/topic_providers.dart';

void main() {
  test(
    'Ẩn đề tài chờ duyệt của người khác nhưng giữ đề tài của mình',
    () async {
      final container = _container();
      addTearDown(container.dispose);
      final subscription = container.listen(visibleTopicsProvider, (_, _) {});
      addTearDown(subscription.close);

      await container.read(topicsProvider.future);
      final topics = container.read(visibleTopicsProvider).requireValue;

      expect(
        topics.any(
          (topic) => topic.status == TopicStatus.pending && !topic.isMine,
        ),
        isFalse,
      );
      expect(
        topics.any(
          (topic) => topic.status == TopicStatus.pending && topic.isMine,
        ),
        isTrue,
      );
    },
  );

  test('Tìm kiếm chỉ giữ đề tài có tên khớp từ khóa', () async {
    final container = _container();
    addTearDown(container.dispose);
    final subscription = container.listen(visibleTopicsProvider, (_, _) {});
    addTearDown(subscription.close);

    await container.read(topicsProvider.future);
    container.read(topicSearchProvider.notifier).state = '  robot ';

    final topics = container.read(visibleTopicsProvider).requireValue;

    expect(topics, isNotEmpty);
    expect(
      topics.every((topic) => topic.title.toLowerCase().contains('robot')),
      isTrue,
    );
  });
}

ProviderContainer _container() => ProviderContainer(
  overrides: [topicRepositoryProvider.overrideWithValue(MockTopicRepository())],
);

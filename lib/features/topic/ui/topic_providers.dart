import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;

import '../../../app/env.dart';
import '../../../core/constants/topic_status.dart';
import '../../../core/network/dio_client.dart';
import '../data/api_topic_repository.dart';
import '../data/mock_topic_repository.dart';
import '../data/topic.dart';
import '../data/topic_repository.dart';

final topicRepositoryProvider = Provider<TopicRepository>(
  (ref) => Env.useMock
      ? MockTopicRepository()
      : ApiTopicRepository(ref.watch(dioProvider)),
);

final topicsProvider = FutureProvider.autoDispose<List<Topic>>(
  (ref) => ref.watch(topicRepositoryProvider).list(),
);

final topicSearchProvider = StateProvider.autoDispose<String>((_) => '');

final visibleTopicsProvider = Provider.autoDispose<AsyncValue<List<Topic>>>((
  ref,
) {
  final keyword = ref.watch(topicSearchProvider).trim().toLowerCase();
  return ref
      .watch(topicsProvider)
      .whenData(
        (topics) => topics
            .where(
              (topic) => topic.status != TopicStatus.pending || topic.isMine,
            )
            .where((topic) => topic.title.toLowerCase().contains(keyword))
            .toList(),
      );
});

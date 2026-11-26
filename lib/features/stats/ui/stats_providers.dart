import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/env.dart';
import '../../../core/network/dio_client.dart';
import '../data/api_stats_repository.dart';
import '../data/mock_stats_repository.dart';
import '../data/stats_repository.dart';
import '../data/topic_stats.dart';

final statsRepositoryProvider = Provider<StatsRepository>(
  (ref) => Env.useMock
      ? MockStatsRepository()
      : ApiStatsRepository(ref.watch(dioProvider)),
);

final topicStatsProvider = FutureProvider.autoDispose<TopicStats>(
  (ref) => ref.watch(statsRepositoryProvider).getTopicStats(),
);

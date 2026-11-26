import 'topic_stats.dart';

abstract class StatsRepository {
  Future<TopicStats> getTopicStats();

  Future<void> exportExcel();
}

import 'package:file_saver/file_saver.dart';

import 'sample_workbook.dart';
import 'stats_repository.dart';
import 'topic_stats.dart';

class MockStatsRepository implements StatsRepository {
  @override
  Future<TopicStats> getTopicStats() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const TopicStats(cancelled: 3, approved: 8, late: 2);
  }

  @override
  Future<void> exportExcel() async {
    await FileSaver.instance.saveFile(
      name: 'bao-cao-de-tai',
      bytes: createSampleWorkbook(),
      fileExtension: 'xlsx',
      mimeType: MimeType.microsoftExcel,
    );
  }
}

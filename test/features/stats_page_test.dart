import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/features/manager/stats_page.dart';
import 'package:nckh_app/features/stats/data/mock_stats_repository.dart';
import 'package:nckh_app/features/stats/data/stats_repository.dart';
import 'package:nckh_app/features/stats/data/topic_stats.dart';
import 'package:nckh_app/features/stats/ui/stats_providers.dart';

void main() {
  testWidgets('Hiển thị đủ ba nhóm số liệu và bảng dữ liệu', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          statsRepositoryProvider.overrideWithValue(MockStatsRepository()),
        ],
        child: const MaterialApp(home: Scaffold(body: StatsPage())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('HỦY'), findsWidgets);
    expect(find.text('DUYỆT'), findsWidgets);
    expect(find.text('TRỄ'), findsWidgets);
    expect(find.text('3'), findsWidgets);
    expect(find.text('8'), findsWidgets);
    expect(find.text('2'), findsWidgets);
    expect(find.text('Xuất EXCEL'), findsOneWidget);
  });

  testWidgets('Thông báo khi xuất tệp Excel thành công', (tester) async {
    final repository = _StatsRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [statsRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: Scaffold(body: StatsPage())),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Xuất EXCEL'));
    await tester.pumpAndSettle();

    expect(repository.wasExported, isTrue);
    expect(find.text('Xuất tệp Excel thành công.'), findsOneWidget);
  });
}

class _StatsRepository implements StatsRepository {
  bool wasExported = false;

  @override
  Future<TopicStats> getTopicStats() async =>
      const TopicStats(cancelled: 3, approved: 8, late: 2);

  @override
  Future<void> exportExcel() async {
    wasExported = true;
  }
}

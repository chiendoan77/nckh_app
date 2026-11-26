import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/features/manager/topic_review_page.dart';
import 'package:nckh_app/features/topic/data/mock_topic_repository.dart';
import 'package:nckh_app/features/topic/ui/topic_providers.dart';

void main() {
  testWidgets('Hiển thị thao tác theo trạng thái đề tài và yêu cầu lý do hủy', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          topicRepositoryProvider.overrideWithValue(MockTopicRepository()),
        ],
        child: const MaterialApp(home: Scaffold(body: TopicReviewPage())),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Ứng dụng học máy');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xem chi tiết'));
    await tester.pumpAndSettle();
    expect(find.text('PHÊ DUYỆT'), findsOneWidget);
    expect(find.text('HỦY ĐỀ TÀI'), findsOneWidget);

    await tester.tap(find.text('HỦY ĐỀ TÀI'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gửi yêu cầu hủy'));
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập lý do hủy đề tài.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'Không đủ điều kiện');
    await tester.tap(find.text('Gửi yêu cầu hủy'));
    await tester.pumpAndSettle();
    expect(find.text('Bạn có chắc chắn muốn hủy đề tài này?'), findsOneWidget);
  });
}

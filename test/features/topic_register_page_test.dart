import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/features/student/topic_register_page.dart';
import 'package:nckh_app/features/topic/data/mock_topic_repository.dart';
import 'package:nckh_app/features/topic/ui/topic_providers.dart';

void main() {
  testWidgets('Đăng ký thành công và báo lỗi khi đăng ký đề tài thứ hai', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          topicRepositoryProvider.overrideWithValue(MockTopicRepository()),
        ],
        child: const MaterialApp(home: Scaffold(body: TopicRegisterPage())),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Xem chi tiết').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Đăng ký'));
    await tester.pumpAndSettle();
    expect(find.text('Đăng ký thành công.'), findsOneWidget);

    await tester.tap(find.text('Xem chi tiết').at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Đăng ký'));
    await tester.pumpAndSettle();

    expect(find.text('Sinh viên đã đăng ký đề tài khác.'), findsOneWidget);
  });

  testWidgets('Gửi đề xuất hợp lệ và hiện thông báo thành công', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          topicRepositoryProvider.overrideWithValue(MockTopicRepository()),
        ],
        child: const MaterialApp(home: Scaffold(body: TopicRegisterPage())),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('+ Đề xuất đề tài'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Đề tài mới');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Mô tả đề tài mới',
    );
    await tester.tap(find.text('Gửi đề xuất'));
    await tester.pumpAndSettle();

    expect(find.text('Đề xuất đề tài thành công.'), findsOneWidget);
    expect(find.text('Gửi đề xuất'), findsNothing);
  });
}

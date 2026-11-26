import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/core/auth/session.dart';
import 'package:nckh_app/core/auth/user.dart';
import 'package:nckh_app/core/constants/user_role.dart';
import 'package:nckh_app/features/topic/data/mock_topic_repository.dart';
import 'package:nckh_app/features/topic/ui/topic_providers.dart';
import 'package:nckh_app/features/teacher/active_topics_page.dart';
import 'package:nckh_app/features/teacher/completed_topics_page.dart';

void main() {
  testWidgets('Giảng viên chỉ thấy đề tài đang hướng dẫn của mình', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionProvider.overrideWith(_TeacherSession.new),
          topicRepositoryProvider.overrideWithValue(MockTopicRepository()),
        ],
        child: const MaterialApp(home: Scaffold(body: ActiveTopicsPage())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nền tảng thư viện số'), findsOneWidget);
    expect(find.text('Mô hình nông nghiệp thông minh'), findsOneWidget);
    expect(find.text('Nhận dạng biển báo giao thông'), findsNothing);
    await tester.tap(find.text('Xem chi tiết').first);
    await tester.pumpAndSettle();
    expect(find.textContaining('Giai đoạn:'), findsOneWidget);
    expect(find.text('Nguyễn Minh Anh'), findsOneWidget);
    expect(find.text('Tài liệu hướng dẫn'), findsOneWidget);
  });

  testWidgets('Trang hoàn thành hiển thị hạn chấm và mở form chấm điểm', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionProvider.overrideWith(_TeacherSession.new),
          topicRepositoryProvider.overrideWithValue(MockTopicRepository()),
        ],
        child: const MaterialApp(home: Scaffold(body: CompletedTopicsPage())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hạn chấm: 30/06/2026'), findsOneWidget);
    expect(find.text('Chấm điểm'), findsWidgets);
  });
}

class _TeacherSession extends SessionNotifier {
  @override
  Session? build() => const Session(
    token: 'test-token',
    user: User(
      name: 'Trần Văn Bình',
      role: UserRole.teacher,
      teacherId: 'GV001',
    ),
    activeRole: UserRole.teacher,
  );
}

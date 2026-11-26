import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/features/council/data/mock_council_repository.dart';
import 'package:nckh_app/features/council/ui/council_providers.dart';
import 'package:nckh_app/features/manager/council_page.dart';
import 'package:nckh_app/features/topic/data/mock_topic_repository.dart';
import 'package:nckh_app/features/topic/data/topic.dart';
import 'package:nckh_app/features/topic/ui/topic_providers.dart';
import 'package:nckh_app/features/user/data/mock_teacher_repository.dart';
import 'package:nckh_app/features/user/data/teacher.dart';
import 'package:nckh_app/features/user/ui/user_providers.dart';

void main() {
  testWidgets('Không tạo hội đồng khi thiếu tên và tạo được khi hợp lệ', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          councilRepositoryProvider.overrideWithValue(MockCouncilRepository()),
          teacherRepositoryProvider.overrideWithValue(MockTeacherRepository()),
          topicRepositoryProvider.overrideWithValue(MockTopicRepository()),
        ],
        child: const MaterialApp(home: Scaffold(body: CouncilPage())),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('+ Thêm nhóm'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tạo hội đồng'));
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập tên hội đồng.'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).first,
      'Hội đồng thử nghiệm',
    );
    await tester.tap(find.text('Tạo hội đồng'));
    await tester.pumpAndSettle();
    expect(find.text('Hội đồng thử nghiệm'), findsOneWidget);
  });

  testWidgets('Chi tiết hội đồng chỉ cho chọn đề tài đã duyệt', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          councilRepositoryProvider.overrideWithValue(MockCouncilRepository()),
          teacherRepositoryProvider.overrideWithValue(MockTeacherRepository()),
          topicRepositoryProvider.overrideWithValue(MockTopicRepository()),
        ],
        child: const MaterialApp(home: Scaffold(body: CouncilPage())),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hội đồng đề cương 1'));
    await tester.pumpAndSettle();

    expect(find.text('Phân công thành viên'), findsOneWidget);
    expect(find.text('Gắn đề tài'), findsOneWidget);
    await tester.tap(find.byType(DropdownButton<Topic>));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Ứng dụng học máy trong giáo dục'),
      findsNothing,
    );
    expect(
      find.textContaining('Ứng dụng robot hỗ trợ phòng thí nghiệm'),
      findsOneWidget,
    );
  });

  testWidgets('Có thể thêm thành viên và thành viên đã thêm không chọn lại', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          councilRepositoryProvider.overrideWithValue(MockCouncilRepository()),
          teacherRepositoryProvider.overrideWithValue(MockTeacherRepository()),
          topicRepositoryProvider.overrideWithValue(MockTopicRepository()),
        ],
        child: const MaterialApp(home: Scaffold(body: CouncilPage())),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hội đồng đề cương 1'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton<Teacher>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('GV006 · Võ Ngọc Lan').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('APPLY').first);
    await tester.pumpAndSettle();

    expect(find.text('Võ Ngọc Lan'), findsNWidgets(2));
    await tester.tap(find.byType(DropdownButton<Teacher>));
    await tester.pumpAndSettle();
    expect(find.text('GV006 · Võ Ngọc Lan'), findsNothing);
  });
}

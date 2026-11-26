import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/features/admin/teacher_manage_page.dart';
import 'package:nckh_app/features/user/data/mock_teacher_repository.dart';
import 'package:nckh_app/features/user/ui/user_providers.dart';
import 'package:nckh_app/shared/widgets/list_row.dart';

void main() {
  testWidgets(
    'Hai tab lọc đúng giảng viên và quản lý, kể cả người kiêm nhiệm',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            teacherRepositoryProvider.overrideWithValue(
              MockTeacherRepository(),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: TeacherManagePage())),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListRow), findsNWidgets(20));
      expect(find.text('GV002'), findsOneWidget);

      await tester.tap(find.text('Quản lý'));
      await tester.pumpAndSettle();
      expect(find.byType(ListRow), findsNWidgets(4));
      expect(find.text('GV002'), findsOneWidget);

      await tester.tap(find.byKey(const Key('add-teacher')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('teacher-id')), 'GV023');
      await tester.enterText(
        find.byKey(const Key('teacher-name')),
        'Người mới',
      );
      await tester.enterText(
        find.byKey(const Key('teacher-degree')),
        'Thạc sĩ',
      );
      await tester.enterText(
        find.byKey(const Key('teacher-faculty')),
        'Kỹ thuật',
      );
      await tester.enterText(
        find.byKey(const Key('teacher-email')),
        'new@example.edu.vn',
      );
      await tester.tap(find.text('Lưu'));
      await tester.pumpAndSettle();

      expect(find.text('Chọn ít nhất một chức vụ.'), findsOneWidget);
      expect(find.byType(ListRow), findsNWidgets(4));

      await tester.tap(find.byKey(const Key('teacher-role-manager')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lưu'));
      await tester.pumpAndSettle();

      expect(find.byType(ListRow), findsNWidgets(5));
      expect(find.text('GV023'), findsOneWidget);
    },
  );
}

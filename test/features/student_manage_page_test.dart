import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/features/admin/student_manage_page.dart';
import 'package:nckh_app/features/user/data/mock_student_repository.dart';
import 'package:nckh_app/features/user/ui/user_providers.dart';
import 'package:nckh_app/shared/widgets/list_row.dart';

void main() {
  testWidgets('Có thể thêm và xóa sinh viên qua xác nhận', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = MockStudentRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [studentRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: Scaffold(body: StudentManagePage())),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('+ Thêm sinh viên'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('student-id')), 'SV026');
    await tester.enterText(
      find.byKey(const Key('student-name')),
      'Sinh viên mới',
    );
    await tester.enterText(find.byKey(const Key('student-major')), 'Kỹ thuật');
    await tester.enterText(find.byKey(const Key('student-gpa')), '3.7');
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();

    expect(find.text('Tổng: 26'), findsOneWidget);

    await tester.tap(find.text('Xóa').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xác nhận'));
    await tester.pumpAndSettle();

    expect(find.text('Tổng: 25'), findsOneWidget);
    final studentsFuture = repository.list();
    await tester.pump(const Duration(milliseconds: 300));
    final students = await studentsFuture;
    expect(students.any((student) => student.id == 'SV001'), isFalse);
  });

  testWidgets('Phân trang 25 sinh viên thành 20 và 5, thống kê đổi khi sửa', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          studentRepositoryProvider.overrideWithValue(MockStudentRepository()),
        ],
        child: const MaterialApp(home: Scaffold(body: StudentManagePage())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tổng: 25'), findsOneWidget);
    expect(find.text('Hoạt động: 20'), findsOneWidget);
    expect(find.text('Đình chỉ: 5'), findsOneWidget);
    expect(find.byType(ListRow), findsNWidgets(20));

    await tester.tap(find.text('2'));
    await tester.pumpAndSettle();
    expect(find.byType(ListRow), findsNWidgets(5));
    await tester.tap(find.text('1'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sửa').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('student-status')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Đình chỉ').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Lưu'));
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();

    expect(find.text('Hoạt động: 19'), findsOneWidget);
    expect(find.text('Đình chỉ: 6'), findsOneWidget);
  });
}

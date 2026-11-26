import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/core/auth/session.dart';
import 'package:nckh_app/core/auth/user.dart';
import 'package:nckh_app/core/constants/user_role.dart';
import 'package:nckh_app/features/grading/data/mock_grade_repository.dart';
import 'package:nckh_app/features/student/grade_lookup_page.dart';
import 'package:nckh_app/features/grading/ui/grade_providers.dart';

void main() {
  testWidgets('Lọc bảng điểm và xem thành viên, nhận xét, kỳ báo cáo', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer(
      overrides: [
        gradeRepositoryProvider.overrideWithValue(MockGradeRepository()),
      ],
    );
    container
        .read(sessionProvider.notifier)
        .login(
          'mock-token',
          const User(
            name: 'Nguyễn Minh Anh',
            role: UserRole.student,
            studentId: 'SV001',
          ),
          UserRole.student,
        );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: GradeLookupPage())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Trợ lý tra cứu tài liệu'), findsOneWidget);
    expect(find.text('Phân loại rác thải tại nguồn'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'rác');
    await tester.pumpAndSettle();

    expect(find.text('Trợ lý tra cứu tài liệu'), findsNothing);
    expect(find.text('Phân loại rác thải tại nguồn'), findsOneWidget);
    await tester.tap(find.text('Phân loại rác thải tại nguồn'));
    await tester.pumpAndSettle();

    expect(find.text('Thành viên và điểm'), findsOneWidget);
    expect(find.text('Kết quả triển khai tốt.'), findsOneWidget);
    expect(find.textContaining('2025–2026'), findsNWidgets(2));
    expect(find.textContaining('9,00'), findsNWidgets(2));
  });
}

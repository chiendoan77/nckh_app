import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/features/user/data/mock_student_repository.dart';
import 'package:nckh_app/features/user/ui/profile_panel.dart';
import 'package:nckh_app/features/user/ui/user_providers.dart';

void main() {
  testWidgets('Sửa hồ sơ chỉ cập nhật họ tên và chuyên ngành', (tester) async {
    final repository = MockStudentRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [studentRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(
          home: Scaffold(body: ProfilePanel(studentId: 'SV001')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Chỉnh sửa'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Nguyễn Minh Anh cập nhật',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Khoa học dữ liệu',
    );
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();

    expect(find.text('Nguyễn Minh Anh cập nhật'), findsOneWidget);
    expect(find.text('Khoa học dữ liệu'), findsOneWidget);
    expect(find.text('3,42'), findsOneWidget);
  });
}

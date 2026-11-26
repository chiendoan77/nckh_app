// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nckh_app/app/app.dart';

void main() {
  testWidgets('Hiển thị màn hình giới thiệu', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: NckhApp()));
    await tester.pumpAndSettle();

    expect(
      find.text('Hệ thống quản lý đề tài nghiên cứu khoa học'),
      findsOneWidget,
    );
    expect(find.text('Đăng nhập'), findsOneWidget);
  });
}

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:nckh_app/main.dart';
import 'package:nckh_app/shared/widgets/hexagon_logo.dart';
import 'package:nckh_app/shared/widgets/user_avatar.dart';

void main() {
  testWidgets('Hiển thị màn hình demo thành phần nền tảng', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NckhApp());

    expect(find.text('Thành phần nền tảng'), findsOneWidget);
    expect(find.text('Nút chính'), findsOneWidget);
    expect(find.text('Nút phụ'), findsOneWidget);
    expect(find.text('Nút nguy hiểm'), findsOneWidget);
    expect(find.byType(HexagonLogo), findsOneWidget);
    expect(find.byType(UserAvatar), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/shared/widgets/pager_bar.dart';

void main() {
  testWidgets('Ẩn bộ phân trang tối đa 20 bản ghi', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: PagerBar(total: 20, page: 1, onChanged: _noop)),
      ),
    );

    expect(find.byType(PagerBar), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });

  testWidgets('Hiện phân trang khi vượt quá 20 bản ghi', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: PagerBar(total: 21, page: 1, onChanged: _noop)),
      ),
    );

    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });
}

void _noop(int page) {}

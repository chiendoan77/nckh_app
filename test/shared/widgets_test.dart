import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/app/theme/app_theme.dart';
import 'package:nckh_app/app/theme/app_tokens.dart';
import 'package:nckh_app/core/constants/topic_status.dart';
import 'package:nckh_app/shared/widgets/app_button.dart';
import 'package:nckh_app/shared/widgets/state_views.dart';
import 'package:nckh_app/shared/widgets/status_badge.dart';

void main() {
  test('Theme dùng màu chủ đạo và kiểu điều khiển đã thống nhất', () {
    final theme = AppTheme.of(null);
    final buttonStyle = theme.filledButtonTheme.style!;

    expect(theme.colorScheme.primary, AppTokens.sidebar);
    expect(theme.colorScheme.onPrimary, AppTokens.sidebarText);
    expect(buttonStyle.elevation?.resolve({}), 0);
    expect(
      buttonStyle.padding?.resolve({}),
      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    );
    expect(buttonStyle.textStyle?.resolve({})?.fontWeight, FontWeight.w600);
    expect(theme.inputDecorationTheme.filled, isTrue);
    expect(theme.inputDecorationTheme.fillColor, AppTokens.surface);
    expect(theme.progressIndicatorTheme.color, AppTokens.sidebar);
  });

  testWidgets('Hiển thị nhãn cho đủ bảy trạng thái', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Wrap(
            children: [
              for (final status in TopicStatus.values)
                StatusBadge(status: status),
            ],
          ),
        ),
      ),
    );

    for (final status in TopicStatus.values) {
      expect(find.text(status.label), findsOneWidget);
    }
  });

  testWidgets('Nhãn trạng thái dùng màu chữ có độ tương phản rõ', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.of(null),
        home: const Scaffold(body: StatusBadge(status: TopicStatus.draft)),
      ),
    );

    final label = tester.widget<Text>(find.text(TopicStatus.draft.label));

    expect(label.style?.color, AppTokens.text);
  });

  testWidgets('Nút gọi hành động khi được nhấn', (tester) async {
    var wasPressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(label: 'Lưu', onPressed: () => wasPressed = true),
        ),
      ),
    );

    await tester.tap(find.text('Lưu'));

    expect(wasPressed, isTrue);
  });

  testWidgets('Lỗi có nút thử lại', (tester) async {
    var retried = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorView(
            message: 'Không tải được dữ liệu.',
            onRetry: () => retried = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Thử lại'));

    expect(retried, isTrue);
  });
}

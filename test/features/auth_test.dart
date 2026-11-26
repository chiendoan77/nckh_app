import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/app/app.dart';
import 'package:nckh_app/app/router/app_router.dart';
import 'package:nckh_app/app/router/paths.dart';
import 'package:nckh_app/app/theme/app_tokens.dart';
import 'package:nckh_app/core/auth/session.dart';
import 'package:nckh_app/shared/layout/app_shell.dart';

void main() {
  testWidgets('Sai mật khẩu báo lỗi và vẫn ở trang đăng nhập', (tester) async {
    final container = await _openLogin(tester);
    addTearDown(container.dispose);

    await tester.enterText(find.byKey(const Key('username-field')), 'sv001');
    await tester.enterText(
      find.byKey(const Key('password-field')),
      'sai-mat-khau',
    );
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Sai tên đăng nhập hoặc mật khẩu'), findsOneWidget);
    expect(
      container
          .read(routerProvider)
          .routerDelegate
          .currentConfiguration
          .uri
          .path,
      Paths.login,
    );
    expect(container.read(sessionProvider), isNull);
  });

  testWidgets('Tài khoản sinh viên vào thẳng trang chủ sinh viên', (
    tester,
  ) async {
    final container = await _loginAs(tester, 'sv001', '123456');
    addTearDown(container.dispose);

    expect(
      container
          .read(routerProvider)
          .routerDelegate
          .currentConfiguration
          .uri
          .path,
      Paths.studentTopics,
    );
    await _openMenu(tester);
    expect(find.text('Đăng ký đề tài'), findsOneWidget);
    expect(find.text('+ Đề xuất đề tài'), findsOneWidget);
    expect(find.text('Tra cứu điểm'), findsOneWidget);
    expect(find.text('Công việc'), findsNothing);

    await tester.tap(find.text('Đăng xuất'));
    await tester.pumpAndSettle();

    expect(container.read(sessionProvider), isNull);
    expect(
      container
          .read(routerProvider)
          .routerDelegate
          .currentConfiguration
          .uri
          .path,
      Paths.login,
    );
  });

  testWidgets('Tài khoản giảng viên vào trang công việc', (tester) async {
    final container = await _loginAs(tester, 'gv001', '123456');
    addTearDown(container.dispose);

    expect(
      container
          .read(routerProvider)
          .routerDelegate
          .currentConfiguration
          .uri
          .path,
      Paths.teacherActive,
    );
    await _openMenu(tester);
    expect(find.text('Công việc'), findsNWidgets(2));
    expect(find.text('Hoàn thành'), findsOneWidget);
    expect(find.text('Thống kê'), findsNothing);
  });

  testWidgets('Tài khoản quản trị vào trang quản lý sinh viên', (tester) async {
    final container = await _loginAs(tester, 'admin', 'admin123');
    addTearDown(container.dispose);

    expect(
      container
          .read(routerProvider)
          .routerDelegate
          .currentConfiguration
          .uri
          .path,
      Paths.adminStudents,
    );
    final theme = Theme.of(tester.element(find.byType(AppShell)));
    expect(theme.scaffoldBackgroundColor, AppTokens.adminBg);
    await _openMenu(tester);
    expect(find.text('Sinh viên'), findsOneWidget);
    expect(find.text('Giảng viên'), findsOneWidget);
  });

  testWidgets('Giảng viên kiêm quản lý chọn vai trò sau khi đăng nhập', (
    tester,
  ) async {
    final container = await _openLogin(tester);
    addTearDown(container.dispose);

    await tester.enterText(find.byKey(const Key('username-field')), 'gv002');
    await tester.enterText(find.byKey(const Key('password-field')), '123456');
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Chọn chức vụ'), findsOneWidget);
    await tester.tap(find.text('Quản lý'));
    await tester.pumpAndSettle();

    expect(
      container
          .read(routerProvider)
          .routerDelegate
          .currentConfiguration
          .uri
          .path,
      Paths.managerTopics,
    );
    expect(container.read(sessionProvider)?.activeRole.name, 'manager');
    await _openMenu(tester);
    expect(find.text('Danh sách đề tài'), findsNWidgets(2));
    expect(find.text('Hội đồng chấm'), findsOneWidget);
    expect(find.text('Thống kê'), findsOneWidget);
  });
}

Future<ProviderContainer> _loginAs(
  WidgetTester tester,
  String username,
  String password,
) async {
  final container = await _openLogin(tester);
  await tester.enterText(find.byKey(const Key('username-field')), username);
  await tester.enterText(find.byKey(const Key('password-field')), password);
  await tester.tap(find.byKey(const Key('login-submit')));
  await tester.pumpAndSettle();
  return container;
}

Future<ProviderContainer> _openLogin(WidgetTester tester) async {
  final container = ProviderContainer();
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const NckhApp()),
  );
  await tester.pumpAndSettle();
  container.read(routerProvider).go(Paths.login);
  await tester.pumpAndSettle();
  return container;
}

Future<void> _openMenu(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Mở menu'));
  await tester.pumpAndSettle();
}

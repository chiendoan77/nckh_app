import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/app/router/app_router.dart';
import 'package:nckh_app/app/router/paths.dart';
import 'package:nckh_app/core/auth/session.dart';
import 'package:nckh_app/core/auth/user.dart';
import 'package:nckh_app/core/constants/user_role.dart';

void main() {
  testWidgets('Khách truy cập trang bảo vệ được chuyển đến đăng nhập', (
    tester,
  ) async {
    final container = await _renderRouter(tester);
    addTearDown(container.dispose);

    container.read(routerProvider).go(Paths.studentTopics);
    await tester.pumpAndSettle();

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

  testWidgets('Người đã đăng nhập rời trang công khai về trang chủ vai trò', (
    tester,
  ) async {
    final container = await _renderRouter(tester, role: UserRole.student);
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
  });

  testWidgets('Vai trò không phù hợp được chuyển đến trang 403', (
    tester,
  ) async {
    final container = await _renderRouter(tester, role: UserRole.student);
    addTearDown(container.dispose);

    container.read(routerProvider).go(Paths.managerTopics);
    await tester.pumpAndSettle();

    expect(
      container
          .read(routerProvider)
          .routerDelegate
          .currentConfiguration
          .uri
          .path,
      Paths.forbidden,
    );
    expect(find.text('Bạn không có quyền truy cập trang này.'), findsOneWidget);
  });

  testWidgets('Đường dẫn không tồn tại hiển thị trang 404', (tester) async {
    final container = await _renderRouter(tester, role: UserRole.student);
    addTearDown(container.dispose);

    container.read(routerProvider).go('/not-found');
    await tester.pumpAndSettle();

    expect(find.text('Không tìm thấy trang.'), findsOneWidget);
  });
}

Future<ProviderContainer> _renderRouter(
  WidgetTester tester, {
  UserRole? role,
}) async {
  final container = ProviderContainer();
  if (role != null) {
    container
        .read(sessionProvider.notifier)
        .login('test-token', User(name: 'Nguyễn An', role: role), role);
  }
  final router = container.read(routerProvider);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

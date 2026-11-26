import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/auth/session.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class NckhApp extends ConsumerWidget {
  const NckhApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    return MaterialApp.router(
      title: 'Quản lý NCKH – ĐH Quy Nhơn',
      theme: AppTheme.of(session?.activeRole),
      routerConfig: ref.watch(routerProvider),
    );
  }
}

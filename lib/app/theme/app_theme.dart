import 'package:flutter/material.dart';

import '../../core/constants/user_role.dart';
import 'app_tokens.dart';

class AppTheme {
  static ThemeData of(UserRole? role) => role == UserRole.admin
      ? _build(AppTokens.adminBg, AppTokens.adminText)
      : _build(AppTokens.bg, AppTokens.text);

  static ThemeData _build(Color background, Color foreground) => ThemeData(
    useMaterial3: true,
    fontFamily: AppTokens.fontFamily,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppTokens.sidebar,
      surface: background,
      onSurface: foreground,
    ),
    textTheme: AppTokens.textTheme.apply(
      bodyColor: foreground,
      displayColor: foreground,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    dividerTheme: const DividerThemeData(color: AppTokens.border, thickness: 1),
  );
}

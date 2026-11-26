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
      surface: AppTokens.surface,
      onSurface: foreground,
    ).copyWith(primary: AppTokens.sidebar, onPrimary: AppTokens.sidebarText),
    textTheme: AppTokens.textTheme.apply(
      bodyColor: foreground,
      displayColor: foreground,
    ),
    filledButtonTheme: FilledButtonThemeData(style: _buttonStyle),
    textButtonTheme: TextButtonThemeData(style: _buttonStyle),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppTokens.surface,
      border: _inputBorder,
      enabledBorder: _inputBorder,
      focusedBorder: _inputFocusBorder,
      errorBorder: _inputErrorBorder,
      focusedErrorBorder: _inputErrorBorder,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.selected) ? AppTokens.sidebar : null,
      ),
      checkColor: const WidgetStatePropertyAll(AppTokens.sidebarText),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(AppTokens.checkboxRadius),
      ),
    ),
    tabBarTheme: TabBarThemeData(
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: AppTokens.accent, width: 2),
      ),
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: AppTokens.text,
      unselectedLabelColor: AppTokens.textMuted,
      labelStyle: const TextStyle(fontWeight: FontWeight.w700),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      dividerColor: AppTokens.border,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppTokens.surface,
        border: _inputBorder,
        enabledBorder: _inputBorder,
        focusedBorder: _inputFocusBorder,
      ),
      menuStyle: MenuStyle(
        backgroundColor: const WidgetStatePropertyAll(AppTokens.surface),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        elevation: const WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            side: const BorderSide(color: AppTokens.border),
            borderRadius: BorderRadius.all(AppTokens.controlRadius),
          ),
        ),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppTokens.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppTokens.border),
        borderRadius: BorderRadius.all(AppTokens.controlRadius),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppTokens.surface,
      headerBackgroundColor: AppTokens.sidebar,
      headerForegroundColor: AppTokens.sidebarText,
      dayForegroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppTokens.sidebarText
            : AppTokens.text,
      ),
      dayBackgroundColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.selected) ? AppTokens.sidebar : null,
      ),
      todayForegroundColor: const WidgetStatePropertyAll(AppTokens.sidebar),
      todayBackgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      todayBorder: const BorderSide(color: AppTokens.accent),
      yearForegroundColor: const WidgetStatePropertyAll(AppTokens.text),
      yearBackgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppTokens.border),
        borderRadius: BorderRadius.only(
          topLeft: AppTokens.cardRadius,
          topRight: AppTokens.controlRadius,
          bottomLeft: AppTokens.controlRadius,
          bottomRight: AppTokens.cardRadius,
        ),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppTokens.sidebar,
      circularTrackColor: AppTokens.border,
      linearTrackColor: AppTokens.border,
      refreshBackgroundColor: AppTokens.surface,
      strokeWidth: 2.5,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppTokens.text,
        borderRadius: BorderRadius.all(AppTokens.tooltipRadius),
      ),
      textStyle: const TextStyle(color: AppTokens.sidebarText),
    ),
    dividerTheme: const DividerThemeData(color: AppTokens.border, thickness: 1),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(AppTokens.controlRadius),
      ),
      selectedTileColor: AppTokens.sidebar.withValues(alpha: 0.06),
    ),
  );

  static const _controlShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(AppTokens.controlRadius),
  );

  static const _buttonStyle = ButtonStyle(
    shape: WidgetStatePropertyAll(_controlShape),
    elevation: WidgetStatePropertyAll(0),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    ),
    textStyle: WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.w600)),
  );

  static const _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(AppTokens.controlRadius),
    borderSide: BorderSide(color: AppTokens.border),
  );

  static const _inputFocusBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(AppTokens.controlRadius),
    borderSide: BorderSide(color: AppTokens.sidebar, width: 1.5),
  );

  static const _inputErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(AppTokens.controlRadius),
    borderSide: BorderSide(color: AppTokens.danger),
  );
}

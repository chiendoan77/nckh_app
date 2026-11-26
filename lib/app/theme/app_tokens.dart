import 'package:flutter/material.dart';

import '../../core/constants/topic_status.dart';

class AppTokens {
  static const bg = Color(0xFFF4F6F8);
  static const surface = Color(0xFFFFFFFF);
  static const text = Color(0xFF14202B);
  static const textMuted = Color(0xFF5B6670);
  static const sidebar = Color(0xFF0F2A3D);
  static const sidebarText = Color(0xFFF3F6F8);
  static const sidebarActive = Color(0x1FFFFFFF);
  static const accent = Color(0xFFC08A2E);
  static const border = Color(0xFFD8DEE4);
  static const success = Color(0xFF2F7D5B);
  static const danger = Color(0xFFB4382C);
  static const adminBg = Color(0xFFFFF1E0);
  static const adminSidebar = Color(0xFFFFD8A8);
  static const adminSidebarActive = Color(0x1F000000);
  static const adminText = Color(0xFF2A1F12);

  static Color statusColor(TopicStatus status) => switch (status) {
    TopicStatus.pending => const Color(0xFFC77B12),
    TopicStatus.approved => success,
    TopicStatus.inProgress => const Color(0xFF2F6F9F),
    TopicStatus.extended => const Color(0xFF6B5B95),
    TopicStatus.completed => sidebar,
    TopicStatus.cancelled => danger,
    TopicStatus.draft => border,
  };

  static const controlRadius = Radius.circular(6);
  static const cardRadius = Radius.circular(14);
  static const readableWidth = 650.0;
  static const sidebarWidth = 260.0;

  static const fontFamily = 'BeVietnamPro';
  static const headingFamily = 'SourceSerif4';
  static const fontFamilyFallback = ['Roboto'];
  static const textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: headingFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: 34,
      height: 1.25,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.4,
    ),
    headlineMedium: TextStyle(
      fontFamily: headingFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: 26,
      height: 1.3,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
    ),
    titleLarge: TextStyle(
      fontFamily: headingFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: 19,
      height: 1.35,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: 16,
      height: 1.55,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: 15,
      height: 1.55,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: 13,
      height: 1.45,
      letterSpacing: 0.1,
    ),
  );
}

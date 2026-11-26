import 'package:flutter/material.dart';

import '../../core/constants/topic_status.dart';

class AppTokens {
  static const bg = Color(0xFFFFFFFF);
  static const text = Color(0xFF111111);
  static const sidebar = Color(0xFF0F2A3D);
  static const sidebarText = Color(0xFFFFFFFF);
  static const border = Color(0xFFD0D5DD);
  static const success = Color(0xFF12B76A);
  static const danger = Color(0xFFD92D20);
  static const adminBg = Color(0xFFFFE8CC);
  static const adminSidebar = Color(0xFFFFD8A8);
  static const adminText = Color(0xFF000000);

  static Color statusColor(TopicStatus status) => switch (status) {
    TopicStatus.pending => const Color(0xFFF79009),
    TopicStatus.approved => success,
    TopicStatus.inProgress => const Color(0xFF2E90FA),
    TopicStatus.extended => const Color(0xFF7A5AF8),
    TopicStatus.completed => sidebar,
    TopicStatus.cancelled => danger,
    TopicStatus.draft => border,
  };

  static const cardRadius = Radius.circular(12);
  static const readableWidth = 650.0;
  static const sidebarWidth = 260.0;

  static const fontFamily = 'Roboto';
  static const textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 36,
      height: 1.4,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: TextStyle(
      fontSize: 26,
      height: 1.4,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      fontSize: 19,
      height: 1.4,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(fontSize: 17, height: 1.5),
    bodyMedium: TextStyle(fontSize: 16, height: 1.5),
    bodySmall: TextStyle(fontSize: 13, height: 1.4),
  );
}

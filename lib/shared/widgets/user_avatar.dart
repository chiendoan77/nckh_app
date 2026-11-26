import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.name, this.radius = 20});

  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final trimmedName = name.trim();
    final initial = trimmedName.isEmpty ? 'N' : trimmedName[0].toUpperCase();
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppTokens.sidebar,
      foregroundColor: AppTokens.sidebarText,
      child: Text(initial),
    );
  }
}

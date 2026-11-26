import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_tokens.dart';
import '../../core/auth/session.dart';
import '../../core/constants/user_role.dart';
import '../../shared/widgets/hexagon_logo.dart';
import 'nav_items.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = role == UserRole.admin;
    final background = isAdmin ? AppTokens.adminSidebar : AppTokens.sidebar;
    final foreground = isAdmin ? AppTokens.adminText : AppTokens.sidebarText;
    final activeColor = isAdmin
        ? AppTokens.adminSidebarActive
        : AppTokens.sidebarActive;
    final location = GoRouterState.of(context).matchedLocation;

    return Material(
      color: background,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const HexagonLogo(size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _roleTitle(role),
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(color: foreground),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            for (final item in navItemsByRole[role] ?? const [])
              ListTile(
                leading: Icon(item.icon),
                title: Text(item.label),
                selected: location == item.path,
                selectedTileColor: activeColor,
                textColor: foreground,
                iconColor: foreground,
                selectedColor: foreground,
                onTap: () => context.go(item.path),
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => ref.read(sessionProvider.notifier).logout(),
                  style: TextButton.styleFrom(foregroundColor: foreground),
                  icon: const Icon(Icons.logout),
                  label: const Text('Đăng xuất'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _roleTitle(UserRole role) => switch (role) {
  UserRole.student => 'NCKH',
  UserRole.teacher => 'Giảng viên',
  UserRole.manager => 'Quản lý',
  UserRole.admin => 'Admin',
};

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
              _NavTile(
                item: item,
                selected: location == item.path,
                foreground: foreground,
                activeColor: activeColor,
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

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.selected,
    required this.foreground,
    required this.activeColor,
    required this.onTap,
  });

  final NavItem item;
  final bool selected;
  final Color foreground;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.all(AppTokens.controlRadius);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: selected ? activeColor : Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 3,
                  height: 20,
                  child: ColoredBox(
                    color: selected ? AppTokens.accent : Colors.transparent,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(item.icon, size: 20, color: foreground),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: foreground,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

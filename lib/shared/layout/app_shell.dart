import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_tokens.dart';
import '../../core/auth/session.dart';
import 'sidebar.dart';
import 'top_bar.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child, this.profileBuilder});

  final Widget child;
  final Widget Function(BuildContext, Session)? profileBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    if (session == null) {
      return const SizedBox.shrink();
    }

    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final sidebar = Sidebar(role: session.activeRole);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: isWide ? null : Drawer(child: sidebar),
      body: Row(
        children: [
          if (isWide) SizedBox(width: AppTokens.sidebarWidth, child: sidebar),
          Expanded(
            child: Column(
              children: [
                TopBar(
                  session: session,
                  showMenu: !isWide,
                  profileBuilder: profileBuilder,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(isWide ? 24 : 16),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

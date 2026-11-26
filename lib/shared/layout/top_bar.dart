import 'package:flutter/material.dart';

import '../../core/auth/session.dart';
import '../../shared/widgets/side_panel.dart';
import '../../shared/widgets/user_avatar.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.session,
    required this.showMenu,
    this.profileBuilder,
  });

  final Session session;
  final bool showMenu;
  final Widget Function(BuildContext, Session)? profileBuilder;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 64,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (showMenu)
            Builder(
              builder: (innerContext) => IconButton(
                tooltip: 'Mở menu',
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(innerContext).openDrawer(),
              ),
            ),
          Expanded(
            child: Text(
              'Trường Đại học Quy Nhơn',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          IconButton(
            tooltip: 'Thông báo',
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          if (MediaQuery.sizeOf(context).width >= 600) ...[
            Flexible(
              child: Text(session.user.name, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 8),
          ],
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () => showSidePanel(
              context,
              profileBuilder?.call(context, session) ??
                  _summary(context, session),
            ),
            child: UserAvatar(name: session.user.name),
          ),
        ],
      ),
    ),
  );

  Widget _summary(BuildContext context, Session session) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(session.user.name, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(session.activeRole.label),
      ],
    ),
  );
}

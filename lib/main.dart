import 'package:flutter/material.dart';

import 'app/theme/app_theme.dart';
import 'app/theme/app_tokens.dart';
import 'core/constants/topic_status.dart';
import 'shared/widgets/app_button.dart';
import 'shared/widgets/app_card.dart';
import 'shared/widgets/card_grid.dart';
import 'shared/widgets/hexagon_logo.dart';
import 'shared/widgets/status_badge.dart';
import 'shared/widgets/user_avatar.dart';

void main() {
  runApp(const NckhApp());
}

class NckhApp extends StatelessWidget {
  const NckhApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Quản lý đề tài nghiên cứu khoa học',
    theme: AppTheme.of(null),
    home: const _FoundationPage(),
  );
}

class _FoundationPage extends StatelessWidget {
  const _FoundationPage();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Row(
        children: [
          const HexagonLogo(),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Nền tảng hệ thống NCKH',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: UserAvatar(name: 'Nguyễn An'),
        ),
      ],
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Thành phần nền tảng',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              AppButton(label: 'Nút chính', onPressed: () {}),
              AppButton(
                label: 'Nút phụ',
                kind: AppButtonKind.ghost,
                onPressed: () {},
              ),
              AppButton(
                label: 'Nút nguy hiểm',
                kind: AppButtonKind.danger,
                onPressed: () {},
              ),
            ],
          ),
        ),
        Expanded(
          child: CardGrid<TopicStatus>(
            items: TopicStatus.values,
            itemBuilder: (context, status) => AppCard(
              statusColor: AppTokens.statusColor(status),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusBadge(status: status),
                  const SizedBox(height: 12),
                  Text(
                    status.label,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Thẻ minh họa trạng thái đề tài.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/topic_status.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/status_badge.dart';
import '../data/topic.dart';

class TopicCard extends StatelessWidget {
  const TopicCard({
    super.key,
    required this.topic,
    required this.onView,
    this.onEdit,
  });

  final Topic topic;
  final VoidCallback onView;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final canEdit =
        onEdit != null && topic.isMine && topic.status == TopicStatus.pending;
    return AppCard(
      statusColor: AppTokens.statusColor(topic.status),
      footer: Wrap(
        spacing: 8,
        children: [
          AppButton(
            label: 'Xem chi tiết',
            kind: AppButtonKind.ghost,
            onPressed: onView,
          ),
          if (canEdit)
            AppButton(
              label: 'Chỉnh sửa',
              kind: AppButtonKind.ghost,
              onPressed: onEdit,
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatusBadge(status: topic.status),
              if (canEdit)
                Text(
                  'PRIVATE',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            topic.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text('Tạo bởi: ${topic.authorName}'),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              topic.description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

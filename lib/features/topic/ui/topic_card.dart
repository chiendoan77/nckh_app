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
    this.onTap,
    this.detailLine,
    this.viewLabel = 'Xem chi tiết',
    this.showAuthor = true,
  });

  final Topic topic;
  final VoidCallback onView;
  final VoidCallback? onEdit;
  final VoidCallback? onTap;
  final String? detailLine;
  final String viewLabel;
  final bool showAuthor;

  @override
  Widget build(BuildContext context) {
    final canEdit =
        onEdit != null && topic.isMine && topic.status == TopicStatus.pending;
    return AppCard(
      statusColor: AppTokens.statusColor(topic.status),
      onTap: onTap,
      footer: Wrap(
        spacing: 8,
        children: [
          AppButton(
            label: viewLabel,
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
          const SizedBox(height: 4),
          Text(
            topic.title,
            maxLines: detailLine == null ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          if (showAuthor) Text('Tạo bởi: ${topic.authorName}'),
          if (detailLine != null) ...[
            const SizedBox(height: 4),
            Text(detailLine!),
          ],
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              topic.description,
              maxLines: detailLine == null ? 4 : 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

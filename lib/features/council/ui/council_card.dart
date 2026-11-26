import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../data/council.dart';

class CouncilCard extends StatelessWidget {
  const CouncilCard({super.key, required this.council, required this.onTap});

  final Council council;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 180,
    child: AppCard(
      statusColor: council.type == CouncilType.outline
          ? AppTokens.sidebar
          : AppTokens.accent,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            council.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '${council.type.label} · ${council.createdOn == null ? 'Chưa có ngày lập' : formatDate(council.createdOn!)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            council.members.isEmpty
                ? 'Chưa có thành viên'
                : council.members.map((member) => member.name).join(', '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}

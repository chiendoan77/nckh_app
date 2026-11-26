import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../data/council.dart';

class CouncilCard extends StatelessWidget {
  const CouncilCard({super.key, required this.council, required this.onTap});

  final Council council;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      title: Text(council.name),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${council.type.label} · ${council.createdOn == null ? 'Chưa có ngày lập' : formatDate(council.createdOn!)}',
            ),
            const SizedBox(height: 4),
            Text(
              council.members.isEmpty
                  ? 'Chưa có thành viên'
                  : council.members.map((member) => member.name).join(', '),
            ),
          ],
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}

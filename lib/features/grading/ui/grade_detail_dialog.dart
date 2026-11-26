import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/dialog_frame.dart';
import '../data/grade.dart';

Future<void> showGradeDetailDialog(BuildContext context, Grade grade) =>
    showDialog<void>(
      context: context,
      builder: (dialogContext) => DialogFrame(
        title: grade.topicTitle,
        actions: [
          AppButton(
            label: 'Đóng',
            kind: AppButtonKind.ghost,
            onPressed: () => Navigator.pop(dialogContext),
          ),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kỳ báo cáo: ${grade.reportTerm}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Thành viên và điểm',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (grade.scores.isEmpty)
              const Text('Chưa có điểm thành viên.')
            else
              for (final score in grade.scores)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(child: Text(score.name)),
                      Text(formatGpa(score.score)),
                    ],
                  ),
                ),
            const SizedBox(height: 8),
            Text('Nhận xét', style: Theme.of(context).textTheme.titleLarge),
            Text(grade.comment),
          ],
        ),
      ),
    );

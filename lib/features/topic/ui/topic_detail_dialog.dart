import 'package:flutter/material.dart';

import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/dialog_frame.dart';
import '../data/topic.dart';

class DialogButton {
  const DialogButton(
    this.label,
    this.onPressed, {
    this.kind = AppButtonKind.primary,
  });

  final String label;
  final VoidCallback onPressed;
  final AppButtonKind kind;
}

Future<void> showTopicDetailDialog(
  BuildContext context,
  Topic topic, {
  List<DialogButton> buttons = const [],
}) => showDialog<void>(
  context: context,
  builder: (dialogContext) => DialogFrame(
    title: topic.title,
    actions: [
      AppButton(
        label: 'Đóng',
        kind: AppButtonKind.ghost,
        onPressed: () => Navigator.pop(dialogContext),
      ),
      for (final button in buttons)
        AppButton(
          label: button.label,
          kind: button.kind,
          onPressed: () {
            Navigator.pop(dialogContext);
            button.onPressed();
          },
        ),
    ],
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sinh viên tạo: ${topic.authorName}'),
        if (topic.supervisor case final supervisor?)
          Text(
            'Giảng viên: ${supervisor.degree} ${supervisor.fullName}'
            ' — ${supervisor.email}',
          ),
        const SizedBox(height: 12),
        Text(topic.description),
      ],
    ),
  ),
);

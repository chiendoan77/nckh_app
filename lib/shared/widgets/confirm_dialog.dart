import 'package:flutter/material.dart';

import 'app_button.dart';
import 'dialog_frame.dart';

Future<bool> showConfirmDialog(
  BuildContext context,
  String message, {
  bool danger = false,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => DialogFrame(
      maxWidth: 440,
      actions: [
        AppButton(
          label: 'Đóng',
          kind: AppButtonKind.ghost,
          onPressed: () => Navigator.pop(context, false),
        ),
        AppButton(
          label: 'Xác nhận',
          kind: danger ? AppButtonKind.danger : AppButtonKind.primary,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
      child: Text(message, style: Theme.of(context).textTheme.bodyLarge),
    ),
  );
  return confirmed ?? false;
}

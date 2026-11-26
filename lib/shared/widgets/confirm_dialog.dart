import 'package:flutter/material.dart';

import 'app_button.dart';

Future<bool> showConfirmDialog(
  BuildContext context,
  String message, {
  bool danger = false,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(message),
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
    ),
  );
  return confirmed ?? false;
}

import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';

class AppToast {
  static void success(BuildContext context, String message) {
    _show(context, message, AppTokens.success);
  }

  static void error(BuildContext context, String message) {
    _show(context, message, AppTokens.danger);
  }

  static void _show(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

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
    final screenWidth = MediaQuery.sizeOf(context).width;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Align(
            alignment: Alignment.centerRight,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTokens.surface,
                  border: Border.all(color: AppTokens.border),
                  borderRadius: BorderRadius.all(AppTokens.controlRadius),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(AppTokens.controlRadius),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Container(width: 4, color: color),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: color,
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    message,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppTokens.text),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          width: screenWidth >= 468 ? 420 : null,
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

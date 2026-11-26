import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';

enum AppButtonKind { primary, ghost, danger }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.kind = AppButtonKind.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonKind kind;

  @override
  Widget build(BuildContext context) => switch (kind) {
    AppButtonKind.primary => FilledButton(
      onPressed: onPressed,
      child: Text(label),
    ),
    AppButtonKind.ghost => TextButton(onPressed: onPressed, child: Text(label)),
    AppButtonKind.danger => FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppTokens.danger,
        foregroundColor: Colors.white,
      ),
      child: Text(label),
    ),
  };
}

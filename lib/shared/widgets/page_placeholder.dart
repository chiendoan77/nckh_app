import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';

class PagePlaceholder extends StatelessWidget {
  const PagePlaceholder({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppTokens.readableWidth),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    ),
  );
}

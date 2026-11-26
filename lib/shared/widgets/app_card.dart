import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.footer,
    this.statusColor,
    this.onTap,
  });

  final Widget child;
  final Widget? footer;
  final Color? statusColor;
  final VoidCallback? onTap;

  static const _radius = BorderRadius.only(
    topLeft: AppTokens.cardRadius,
    bottomRight: AppTokens.cardRadius,
  );

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppTokens.surface,
      border: Border.all(color: AppTokens.border),
      borderRadius: _radius,
    ),
    child: ClipRRect(
      borderRadius: _radius,
      child: Stack(
        children: [
          Positioned.fill(
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: child,
                      ),
                    ),
                    if (footer != null) ...[
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: footer,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 4,
            child: ColoredBox(color: statusColor ?? Colors.transparent),
          ),
        ],
      ),
    ),
  );
}

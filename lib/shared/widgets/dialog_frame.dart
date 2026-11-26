import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';

class DialogFrame extends StatelessWidget {
  const DialogFrame({
    super.key,
    this.title,
    required this.child,
    required this.actions,
    this.onClose,
    this.maxWidth = 560,
  });

  final String? title;
  final Widget child;
  final List<Widget> actions;
  final VoidCallback? onClose;
  final double maxWidth;

  static const _radius = BorderRadius.only(
    topLeft: AppTokens.cardRadius,
    topRight: AppTokens.controlRadius,
    bottomLeft: AppTokens.controlRadius,
    bottomRight: AppTokens.cardRadius,
  );

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    insetPadding: const EdgeInsets.all(24),
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        decoration: BoxDecoration(
          color: AppTokens.surface,
          border: Border.all(color: AppTokens.border),
          borderRadius: _radius,
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F0F2A3D),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: ClipRRect(
            borderRadius: _radius,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 3,
                  width: double.infinity,
                  child: ColoredBox(color: AppTokens.accent),
                ),
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 22, 12, 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            title!,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Đóng',
                          onPressed:
                              onClose ?? () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      28,
                      title == null ? 28 : 16,
                      28,
                      24,
                    ),
                    child: child,
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTokens.bg,
                    border: const Border(
                      top: BorderSide(color: AppTokens.border),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 8,
                    runSpacing: 8,
                    children: actions,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

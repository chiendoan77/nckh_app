import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';
import 'app_button.dart';

class ListRow extends StatelessWidget {
  const ListRow({
    super.key,
    required this.cells,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  final List<Widget> cells;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 56),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppTokens.border)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    child: Row(
      children: [
        for (final cell in cells)
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyMedium!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                child: cell,
              ),
            ),
          ),
        if (onView != null || onEdit != null || onDelete != null)
          Expanded(
            flex: 3,
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 4,
              children: [
                if (onView != null)
                  AppButton(
                    label: 'Xem',
                    kind: AppButtonKind.ghost,
                    onPressed: onView,
                  ),
                if (onEdit != null)
                  AppButton(
                    label: 'Sửa',
                    kind: AppButtonKind.ghost,
                    onPressed: onEdit,
                  ),
                if (onDelete != null)
                  AppButton(
                    label: 'Xóa',
                    kind: AppButtonKind.danger,
                    onPressed: onDelete,
                  ),
              ],
            ),
          ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';

import '../../core/utils/paging.dart';
import 'app_button.dart';

class PagerBar extends StatelessWidget {
  const PagerBar({
    super.key,
    required this.total,
    required this.page,
    required this.onChanged,
  });

  final int total;
  final int page;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final pageCount = (total / pageSize).ceil();
    if (pageCount <= 1) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        children: [
          IconButton(
            tooltip: 'Trang trước',
            onPressed: page > 1 ? () => onChanged(page - 1) : null,
            icon: const Icon(Icons.chevron_left),
          ),
          for (var currentPage = 1; currentPage <= pageCount; currentPage++)
            AppButton(
              label: '$currentPage',
              kind: currentPage == page
                  ? AppButtonKind.primary
                  : AppButtonKind.ghost,
              onPressed: currentPage == page
                  ? null
                  : () => onChanged(currentPage),
            ),
          IconButton(
            tooltip: 'Trang sau',
            onPressed: page < pageCount ? () => onChanged(page + 1) : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

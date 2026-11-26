import 'package:flutter/material.dart';

class CardGrid<T> extends StatelessWidget {
  const CardGrid({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.aspect = 1.25,
  });

  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final double aspect;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 1100
          ? 4
          : constraints.maxWidth >= 760
          ? 2
          : 1;
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: aspect,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) => itemBuilder(context, items[index]),
      );
    },
  );
}

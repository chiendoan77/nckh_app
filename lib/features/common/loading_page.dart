import 'package:flutter/material.dart';

import '../../shared/widgets/hexagon_logo.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HexagonLogo(size: 64),
          const SizedBox(height: 20),
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text('Đang tải...', style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    ),
  );
}

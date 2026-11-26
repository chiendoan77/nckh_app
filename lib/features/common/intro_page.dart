import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';
import '../../shared/widgets/hexagon_logo.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key, required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppTokens.readableWidth),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HexagonLogo(size: 72),
              const SizedBox(height: 20),
              Text(
                'Hệ thống quản lý đề tài nghiên cứu khoa học',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Quản lý đề xuất, thực hiện và đánh giá đề tài nghiên cứu khoa học.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: onLogin, child: const Text('Đăng nhập')),
            ],
          ),
        ),
      ),
    ),
  );
}

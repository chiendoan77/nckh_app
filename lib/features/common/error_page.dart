import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage.forbidden({super.key, required this.onHome})
    : title = 'Không có quyền truy cập',
      message = 'Bạn không có quyền truy cập trang này.';

  const ErrorPage.notFound({super.key, required this.onHome})
    : title = 'Không tìm thấy trang',
      message = 'Không tìm thấy trang.';

  final String title;
  final String message;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          FilledButton(onPressed: onHome, child: const Text('Về trang chủ')),
        ],
      ),
    ),
  );
}

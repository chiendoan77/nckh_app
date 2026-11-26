import 'package:flutter/material.dart';

void main() {
  runApp(const NckhApp());
}

class NckhApp extends StatelessWidget {
  const NckhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý đề tài nghiên cứu khoa học',
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hệ thống quản lý đề tài nghiên cứu khoa học',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text('Dự án đang được khởi tạo.'),
            ],
          ),
        ),
      ),
    );
  }
}

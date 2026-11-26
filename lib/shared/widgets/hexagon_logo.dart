import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';

class HexagonLogo extends StatelessWidget {
  const HexagonLogo({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: const CustomPaint(painter: _HexagonPainter()),
  );
}

class _HexagonPainter extends CustomPainter {
  const _HexagonPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    final outer = _hexagon(center, radius);
    final inner = _hexagon(center, radius * 0.62);
    canvas.drawPath(outer, Paint()..color = AppTokens.sidebar);
    canvas.drawPath(inner, Paint()..color = Colors.white);
  }

  Path _hexagon(Offset center, double radius) {
    final path = Path();
    for (var index = 0; index < 6; index++) {
      final angle = math.pi / 3 * index - math.pi / 2;
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    return path..close();
  }

  @override
  bool shouldRepaint(covariant _HexagonPainter oldDelegate) => false;
}

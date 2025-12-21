import 'package:flutter/material.dart';

class ProgressRing extends CustomPainter {
  final double value; // 0..1
  final Color color;
  ProgressRing({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = Colors.white.withValues(alpha: 0.2);
    final fg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6
      ..color = color;
    canvas.drawCircle(center, radius, bg);
    final sweep = 2 * 3.1415926 * value;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -3.1415926 / 2, sweep, false, fg);
  }

  @override
  bool shouldRepaint(covariant ProgressRing oldDelegate) => oldDelegate.value != value || oldDelegate.color != color;
}


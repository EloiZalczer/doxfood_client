import 'package:flutter/material.dart';

class Compass extends StatelessWidget {
  const Compass({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(30, 30),
      foregroundPainter: CompassPainter(),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 1.0),
          boxShadow: const [BoxShadow(blurRadius: 0.5, color: Colors.grey)],
        ),
      ),
    );
  }
}

class CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final north =
        Paint()
          ..strokeWidth = 2.0
          ..color = Colors.red;

    final south =
        Paint()
          ..strokeWidth = 2.0
          ..color = Colors.grey;

    final southPath =
        Path()
          ..moveTo(size.width * 0.4, size.height * 0.5)
          ..lineTo(size.width * 0.5, size.height * 0.9)
          ..lineTo(size.width * 0.6, size.height * 0.5)
          ..lineTo(size.width * 0.5, size.height * 0.6)
          ..lineTo(size.width * 0.4, size.height * 0.5);

    final northPath =
        Path()
          ..moveTo(size.width * 0.4, size.height * 0.5)
          ..lineTo(size.width * 0.5, size.height * 0.1)
          ..lineTo(size.width * 0.6, size.height * 0.5)
          ..lineTo(size.width * 0.5, size.height * 0.4)
          ..lineTo(size.width * 0.4, size.height * 0.5);

    canvas.drawPath(northPath, north);
    canvas.drawPath(southPath, south);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

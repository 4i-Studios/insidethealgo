import 'package:flutter/material.dart';
import 'dart:math' as math;
class AnimatedTreeConnector extends CustomPainter {
  final double animationValue;
  final bool showMergeFlow;
  final Color lineColor;

  AnimatedTreeConnector({
    this.animationValue = 1.0,
    this.showMergeFlow = false,
    this.lineColor = Colors.grey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor.withOpacity(0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double centerX = size.width / 2;
    final double leftChildX = size.width / 4;
    final double rightChildX = 3 * size.width / 4;

    // Animate line drawing from center to children
    final double animatedHeight = size.height * animationValue;

    // Draw parent to left child connection
    final Path leftPath = Path()
      ..moveTo(centerX, 0)
      ..lineTo(leftChildX, animatedHeight);

    // Draw parent to right child connection
    final Path rightPath = Path()
      ..moveTo(centerX, 0)
      ..lineTo(rightChildX, animatedHeight);

    canvas.drawPath(leftPath, paint);
    canvas.drawPath(rightPath, paint);

    // Draw merge flow indicators during merge phase
    if (showMergeFlow && animationValue > 0.7) {
      _drawMergeFlowIndicators(canvas, size, paint);
    }
  }

  void _drawMergeFlowIndicators(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.purple.shade400;
    paint.strokeWidth = 1.5;

    final double centerX = size.width / 2;
    final double leftChildX = size.width / 4;
    final double rightChildX = 3 * size.width / 4;
    final double midHeight = size.height / 2;

    // Draw upward flow arrows
    _drawArrow(canvas, paint, Offset(leftChildX, size.height), Offset(centerX - 10, midHeight));
    _drawArrow(canvas, paint, Offset(rightChildX, size.height), Offset(centerX + 10, midHeight));
  }

  void _drawArrow(Canvas canvas, Paint paint, Offset start, Offset end) {
    canvas.drawLine(start, end, paint);

    // Draw arrowhead
    final double angle = math.atan2(end.dy - start.dy, end.dx - start.dx);
    final double arrowLength = 8;
    final double arrowAngle = math.pi / 6;

    final Offset arrowPoint1 = Offset(
      end.dx - arrowLength * math.cos(angle - arrowAngle),
      end.dy - arrowLength * math.sin(angle - arrowAngle),
    );

    final Offset arrowPoint2 = Offset(
      end.dx - arrowLength * math.cos(angle + arrowAngle),
      end.dy - arrowLength * math.sin(angle + arrowAngle),
    );

    canvas.drawLine(end, arrowPoint1, paint);
    canvas.drawLine(end, arrowPoint2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
import 'package:flutter/material.dart';
import 'package:puzzle_hack/service/puzzle_service.dart';

import 'model/position.dart';
import 'model/tile.dart';

class AstralPainter extends CustomPainter {
  final List<Position> astralData;
  final Animation animation;
  final Tile tile;
  final Color backgroundColor;

  final animationSize =
      Size(PuzzleService.astralSize + 1, PuzzleService.astralSize + 1);
  AstralPainter(
      this.astralData, this.animation, this.tile, this.backgroundColor)
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final progress = (astralData.length * animation.value).round();
    var paint1 = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    if (tile.isWhitespace) {
      for (int i = astralData.length - 1; i > progress; i--) {
        canvas.drawRect(
            Offset(astralData[astralData.length - i].x.toDouble(),
                    astralData[astralData.length - i].y.toDouble()) &
                animationSize,
            paint1);
      }
    } else {
      for (int i = 0; i < progress; i++) {
        canvas.drawRect(
            Offset(astralData[i].x.toDouble(), astralData[i].y.toDouble()) &
                animationSize,
            paint1);
      }
    }
  }

  @override
  bool shouldRepaint(AstralPainter oldDelegate) {
    return oldDelegate.animation.value > 0 && oldDelegate.animation.value != 2;
  }
}

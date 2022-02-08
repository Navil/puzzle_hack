import 'dart:math';

import 'package:flutter/material.dart';
import 'package:puzzle_hack/model/sand_movement.dart';
import 'package:puzzle_hack/service/puzzle_service.dart';
import 'model/tile.dart';

class SandPainter extends CustomPainter {
  final List<SandMovement> sandData;
  final Animation animation;
  final Color backgroundColor;
  final Tile movingTile;
  final Tile whitespace;

  final animationSize = Size(
      PuzzleService.sandSize.toDouble(), PuzzleService.sandSize.toDouble());

  SandPainter(this.sandData, this.animation, this.movingTile, this.whitespace,
      this.backgroundColor)
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < sandData.length; i++) {
      final from = sandData[i].from;
      final to = sandData[i].to;
      final speed = sandData[i].speed;
      double progress = animation.value * speed;

      canvas.drawRect(
          Offset(8 + from.x + ((to.x - from.x) * min(1, progress)),
                  8 + from.y + ((to.y - from.y)) * min(1, progress)) &
              animationSize,
          paint1);
    }
    //canvas.drawRect(Offset(8, 8) & animationSize, paint1);
  }

  @override
  bool shouldRepaint(SandPainter oldDelegate) {
    return oldDelegate.animation.value > 0 && oldDelegate.animation.value < 1;
  }
}

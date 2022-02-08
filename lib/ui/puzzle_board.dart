import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle_hack/service/puzzle_service.dart';
import 'package:puzzle_hack/ui/puzzle_tile.dart';

import '../sand_painter.dart';
import '../model/position.dart';
import '../model/tile.dart';

class PuzzleBoard extends StatefulWidget {
  const PuzzleBoard({Key? key}) : super(key: key);

  @override
  State<PuzzleBoard> createState() => _PuzzleBoardState();
}

class _PuzzleBoardState extends State<PuzzleBoard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;
  final Tween<double> _rotationTween = Tween(begin: 0, end: 1);

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = _rotationTween.animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Provider.of<PuzzleService>(context, listen: false).tileMoved();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    PuzzleService puzzleService = Provider.of<PuzzleService>(context);

    int size = PuzzleService.size;

    return Stack(children: [
      GridView.builder(
          key: puzzleService.boardKey,
          shrinkWrap: true,
          itemCount: pow(size, 2).toInt(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              crossAxisCount: 4,
              childAspectRatio: 1),
          itemBuilder: (context, index) {
            Tile currentTile = puzzleService.currentPuzzle.tiles.firstWhere(
                (element) =>
                    element.currentPosition.compareTo(Position(
                        x: (index % 4) + 1, y: (index / 4).floor() + 1)) ==
                    0);
            if (currentTile.isWhitespace || currentTile.moving) {
              return Container();
            } else {
              return PuzzleTile(currentTile, animation, onTileClicked);
            }
          }),
      puzzleService.getMovingTile() != null
          ? CustomPaint(
              painter: SandPainter(
                  Provider.of<PuzzleService>(context).sandData,
                  animation,
                  puzzleService.getMovingTile()!,
                  puzzleService.getWhitespaceTile(),
                  Theme.of(context).primaryColor))
          : const SizedBox()
    ]);
  }

  onTileClicked() {
    _controller.reset();
    _controller.forward();
  }
}

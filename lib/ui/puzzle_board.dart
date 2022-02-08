import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle_hack/model/position.dart';
import 'package:puzzle_hack/model/puzzle.dart';
import 'package:puzzle_hack/model/tile.dart';
import 'package:puzzle_hack/service/puzzle_service.dart';
import 'package:puzzle_hack/ui/puzzle_tile.dart';

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
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
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
    Puzzle puzzle = Provider.of<PuzzleService>(context).currentPuzzle;
    int size = PuzzleService.size;

    return GridView.builder(
        shrinkWrap: true,
        itemCount: pow(size, 2).toInt(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, childAspectRatio: 1),
        itemBuilder: (context, index) {
          Tile currentTile = puzzle.tiles.firstWhere((element) =>
              element.currentPosition.compareTo(
                  Position(x: (index % 4) + 1, y: (index / 4).floor() + 1)) ==
              0);
          if (currentTile.isWhitespace &&
              Provider.of<PuzzleService>(context).astralData.isEmpty) {
            return Container();
          } else {
            return PuzzleTile(currentTile, animation, onTileClicked);
          }
        });
  }

  onTileClicked() {
    _controller.reset();
    _controller.forward();
  }
}

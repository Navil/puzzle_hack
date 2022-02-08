import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle_hack/service/puzzle_service.dart';
import 'package:puzzle_hack/ui/puzzle_board.dart';

class PuzzleHack extends StatefulWidget {
  const PuzzleHack({Key? key}) : super(key: key);

  @override
  _PuzzleHackState createState() => _PuzzleHackState();
}

class _PuzzleHackState extends State<PuzzleHack> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCorrectTiles(),
                  _buildNumMoves(),
                  _buildRestart()
                ],
              ),
            ),
            const Flexible(child: PuzzleBoard()),
          ],
        ),
      ),
    );
  }

  Widget _buildCorrectTiles() {
    int correctTiles = Provider.of<PuzzleService>(context)
        .currentPuzzle
        .getNumberOfCorrectTiles();

    if (correctTiles == pow(PuzzleService.size, 2) - 1) {
      return _buildWinText();
    }
    return Column(children: [
      Text(
        correctTiles.toString(),
        style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 32,
            color: Theme.of(context).primaryColor),
      ),
      const Text('Correct'),
    ]);
  }

  Widget _buildNumMoves() {
    return Column(children: [
      Text(
        Provider.of<PuzzleService>(context).numMoves.toString(),
        style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 32,
            color: Theme.of(context).primaryColor),
      ),
      const Text('Moves'),
    ]);
  }

  Widget _buildRestart() {
    return IconButton(
      iconSize: 40,
      icon: Icon(
        Icons.restart_alt,
        color: Theme.of(context).primaryColor,
      ),
      onPressed: Provider.of<PuzzleService>(context).getMovingTile() != null
          ? null
          : () => Provider.of<PuzzleService>(context, listen: false)
              .generatePuzzle(),
    );
  }

  Widget _buildWinText() {
    return Container(
      color: Colors.green,
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text('Puzzle solved!',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../model/position.dart';
import '../model/puzzle.dart';
import '../model/tile.dart';

class PuzzleService extends ChangeNotifier {
  static const int size = 4;
  late Puzzle currentPuzzle;
  List<Position> astralData = [];

  static int astralSize = 10;
  int numMoves = 0;

  PuzzleService() {
    generatePuzzle();
  }

  generatePuzzle() {
    final correctPositions = <Position>[];
    final currentPositions = <Position>[];
    const whitespacePosition = Position(x: size, y: size);

    // Create all possible board positions.
    for (var y = 1; y <= size; y++) {
      for (var x = 1; x <= size; x++) {
        if (x == size && y == size) {
          correctPositions.add(whitespacePosition);
          currentPositions.add(whitespacePosition);
        } else {
          final position = Position(x: x, y: y);
          correctPositions.add(position);
          currentPositions.add(position);
        }
      }
    }

    var tiles = _getTileListFromPositions(
      size,
      correctPositions,
      currentPositions,
    );

    var puzzle = Puzzle(tiles: tiles);

    // Assign the tiles new current positions until the puzzle is solvable and
    // zero tiles are in their correct position.
    while (!puzzle.isSolvable() || puzzle.getNumberOfCorrectTiles() != 0) {
      currentPositions.shuffle();
      tiles = _getTileListFromPositions(
        size,
        correctPositions,
        currentPositions,
      );
      puzzle = Puzzle(tiles: tiles);
    }
    currentPuzzle = puzzle;
    numMoves = 0;
    notifyListeners();
  }

  List<Tile> _getTileListFromPositions(
    int size,
    List<Position> correctPositions,
    List<Position> currentPositions,
  ) {
    final whitespacePosition = Position(x: size, y: size);
    return [
      for (int i = 1; i <= size * size; i++)
        if (i == size * size)
          Tile(
            value: i,
            correctPosition: whitespacePosition,
            currentPosition: currentPositions[i - 1],
            isWhitespace: true,
          )
        else
          Tile(
            value: i,
            correctPosition: correctPositions[i - 1],
            currentPosition: currentPositions[i - 1],
          )
    ];
  }

  Tile getWhitespaceTile() {
    return currentPuzzle.tiles.singleWhere((tile) => tile.isWhitespace);
  }

  Tile? getMovingTile() {
    return currentPuzzle.tiles.firstWhereOrNull((tile) => tile.moving);
  }

  bool isTileMovable(Tile tile) {
    final whitespaceTile = getWhitespaceTile();
    final movingTile = getMovingTile();
    if (tile == whitespaceTile || movingTile != null) {
      return false;
    }

    // A tile must be in the same row or column as the whitespace to move.
    if (whitespaceTile.currentPosition.x != tile.currentPosition.x &&
        whitespaceTile.currentPosition.y != tile.currentPosition.y) {
      return false;
    }
    return true;
  }

  tileClicked(Tile tile) {
    int? width = tile.tileKey.currentContext?.size?.width.ceil().toInt();
    int? height = tile.tileKey.currentContext?.size?.height.ceil().toInt();

    if (width != null && height != null) {
      for (int x = -1; x <= width; x = x + astralSize) {
        for (int y = -1; y <= height; y = y + astralSize) {
          astralData.add(Position(x: x, y: y));
        }
      }
      astralData.shuffle();
      tile.moving = true;
      getWhitespaceTile().value = tile.value;
      notifyListeners();
    }
  }

  tileMoved() {
    Tile? tile = getMovingTile();
    if (tile == null) {
      return;
    }
    astralData.clear();
    tile.moving = false;
    getWhitespaceTile().value = size * size;
    final mutablePuzzle = Puzzle(tiles: [...currentPuzzle.tiles]);
    currentPuzzle = mutablePuzzle.moveTiles(tile, []);
    numMoves = numMoves + 1;
    notifyListeners();
  }
}

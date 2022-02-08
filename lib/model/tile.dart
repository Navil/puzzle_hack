import 'package:flutter/material.dart';
import 'package:puzzle_hack/model/position.dart';

class Tile {
  final GlobalKey tileKey = GlobalKey();

  Tile(
      {required this.value,
      required this.correctPosition,
      required this.currentPosition,
      this.isWhitespace = false,
      this.moving = false});

  /// Value representing the correct position of [Tile] in a list.
  int value;

  /// The correct 2D [Position] of the [Tile]. All tiles must be in their
  /// correct position to complete the puzzle.
  final Position correctPosition;

  /// The current 2D [Position] of the [T
  /// ile].
  final Position currentPosition;

  /// Denotes if the [Tile] is the whitespace tile or not.
  bool isWhitespace;

  bool moving = false;

  /// Create a copy of this [Tile] with updated current position.
  Tile copyWith({required Position currentPosition}) {
    return Tile(
        value: value,
        correctPosition: correctPosition,
        currentPosition: currentPosition,
        isWhitespace: isWhitespace,
        moving: moving);
  }
}

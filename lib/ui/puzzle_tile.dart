import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle_hack/model/tile.dart';
import 'package:puzzle_hack/service/puzzle_service.dart';

class PuzzleTile extends StatefulWidget {
  final Tile tile;
  final Animation<double> animation;
  final VoidCallback onTileClicked;
  const PuzzleTile(this.tile, this.animation, this.onTileClicked, {Key? key})
      : super(key: key);

  @override
  State<PuzzleTile> createState() => _PuzzleTileState();
}

class _PuzzleTileState extends State<PuzzleTile>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    bool isMoveable = Provider.of<PuzzleService>(context, listen: false)
        .isTileMovable(widget.tile);
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: isMoveable
              ? () {
                  Provider.of<PuzzleService>(context, listen: false)
                      .tileClicked(widget.tile);
                  widget.onTileClicked();
                }
              : null,
          mouseCursor: isMoveable
              ? SystemMouseCursors.click
              : SystemMouseCursors.forbidden,
          child: Container(
              key: widget.tile.tileKey,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                child: Text(
                  widget.tile.value.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 40),
                  textAlign: TextAlign.center,
                ),
              )),
        ));
  }
}

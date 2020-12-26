import 'package:flutter/material.dart';
import 'tile.dart';
import 'note.dart';

class Line extends AnimatedWidget {
  final int lineNo;
  final List<Note> currentState;
  final Function(Note) onTileTap;

  const Line(
      {Key key,
      this.lineNo,
      this.currentState,
      this.onTileTap,
      Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = super.listenable;
    double height = MediaQuery.of(context).size.height;
    double tileHeight = height / 4;
    List<Note> particularLine =
        currentState.where((note) => note.line == lineNo).toList();
    List<Widget> tiles = particularLine.map((note) {
      int index = currentState.indexOf(note);
      double offset = (3 - index + animation.value) * tileHeight;
      return Transform.translate(
        offset: Offset(0, offset),
        child: Tile(
          height: tileHeight,
          state: note.state,
          onTap: () => onTileTap(note),
        ),
      );
    }).toList();
    return SizedBox.expand(
      child: Stack(
        children: tiles,
      ),
    );
  }
}

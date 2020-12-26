import 'package:flutter/material.dart';
import 'note.dart';

class Tile extends StatelessWidget {
  final NoteState state;
  final VoidCallback onTap;
  final double height;

  const Tile({Key key, this.height, this.onTap, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: GestureDetector(
          onTapDown: (value)=>onTap(), // parameterised function
        // onTap: onTap,
          child: Container(
            color: color,
          )),
    );
  }

  Color get color {
    switch (state) {
      case NoteState.ready:
        return Colors.black;
      case NoteState.tapped:
        return Colors.white12;
      case NoteState.missed:
        return Colors.red;
        break;
      default:
        return Colors.black;
    }
  }
}

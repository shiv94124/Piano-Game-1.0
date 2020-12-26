class Note {
  int line;
  int orderOfTile;
  NoteState state = NoteState.ready;
  Note(this.orderOfTile, this.line);
}

enum NoteState { ready, tapped, missed }
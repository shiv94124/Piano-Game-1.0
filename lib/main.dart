import 'package:flutter/material.dart';
import 'init_notes.dart';
import 'line.dart';
import 'line_divider.dart';
import 'note.dart';
import 'package:audioplayers/audio_cache.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  AudioCache player=AudioCache();
  List<Note> notes = initNotes();
  AnimationController animationController;
  int currentNoteIndex = 0;
  bool isPlaying = true;
  bool hasStarted = false;
  int point = 0;

  _drawLine(int lineNo) {
    return Expanded(
      child: Line(
        lineNo: lineNo,
        currentState: notes.sublist(currentNoteIndex, currentNoteIndex + 5),
        onTileTap: _onTap,
        animation: animationController,
      ),
    );
  }

  void _onTap(Note note) {
    bool allPreviousTapped = notes
        .sublist(0, note.orderOfTile)
        .every((element) => element.state == NoteState.tapped);
    print(allPreviousTapped);
    if (allPreviousTapped) {
      if (!hasStarted) {
        setState(() {
          hasStarted = true;
        });
        animationController.forward();
      }

      _playMusic(note);
      setState(() {
        notes[currentNoteIndex].state = NoteState.tapped;
        point++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && isPlaying) {
        if (notes[currentNoteIndex].state != NoteState.tapped) {
          setState(() {
            isPlaying = false;
            notes[currentNoteIndex].state = NoteState.missed;
          });
          animationController.reverse().then((value) => _showFinishBox());
        } else if (currentNoteIndex == notes.length - 5) {
          _showFinishBox();
        } else {
          setState(() {
            ++currentNoteIndex;
          });
          animationController.forward(from: 0.0);
        }
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _restart() {
    setState(() {
      isPlaying = true;
      hasStarted = false;
      notes = initNotes();
      currentNoteIndex = 0;
      point = 0;
    });
    animationController.reset();
  }
  _playMusic(Note note){
    switch(note.line){
      case 0:
        player.play('musics/a.wav');
        return ;
      case 1:
        player.play('musics/c.wav');
        return ;
      case 2:
        player.play('musics/e.wav');
        return ;
      case 3:
        player.play('musics/f.wav');
        return ;
    }
  }

  void _showFinishBox() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Game Over\n Score : $point')),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Restart"))
            ],
          );
        }).then((value) => _restart());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/background.jpg",
            fit: BoxFit.cover,
          ),
          Row(
            children: <Widget>[
              _drawLine(0),
              LineDivider(),
              _drawLine(1),
              LineDivider(),
              _drawLine(2),
              LineDivider(),
              _drawLine(3),
            ],
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Text(
              '$point',
              style: TextStyle(fontSize: 50.0, color: Colors.lightGreenAccent),
            ),
          ),
        ],
      ),
    );
  }
}

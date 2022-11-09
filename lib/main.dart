import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) => {runApp(MyApp())});
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterMidi = FlutterMidi();
  @override
  void initState() {
    load(_value);
    super.initState();
  }

  void load(String asset) async {
    _flutterMidi.unmute(); // Optionally Unmute
    ByteData _byte = await rootBundle.load(asset);
    _flutterMidi.prepare(sf2: _byte, name: _value.replaceAll('assets/', ''));
  }

  String _value = 'assets/Yamaha-Grand-Lite-v2.0.sf2';

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        title: 'Piano Demo',
        home: Center(
          child: InteractivePiano(
            highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
            naturalColor: Colors.white,
            accidentalColor: Colors.black,
            keyWidth: 60,
            noteRange: NoteRange.forClefs([
              Clef.Treble,
            ]),
            onNotePositionTapped: (position) {
              debugPrint('$position');
              int myPosition = positionToNum(position);
              debugPrint(myPosition.toString());
              _play(myPosition);
              // Use an audio library like flutter_midi to play the sound
            },
          ),
        ));
  }

  void _play(int midi) {
    _flutterMidi.playMidiNote(midi: midi);
  }

  int positionToNum(NotePosition position) {
    if (position.note == Note.C) {
      return 60;
    } else if (position.note == Note.D) {
      return 62;
    } else if (position.note == Note.E) {
      return 64;
    } else if (position.note == Note.F) {
      return 65;
    } else if (position.note == Note.G) {
      return 67;
    } else if (position.note == Note.A) {
      return 69;
    } else if (position.note == Note.B) {
      return 71;
    } else {
      return 0;
    }
  }
}

enum Notes {
  c,
  d,
  e,
  f,
  g,
  a,
  b,
}

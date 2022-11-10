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
              int myAccidental = acctidentalToNum(position);
              int myOctaveToNum = octaveToNum(position);
              int myPosition = positionToNum(position) +
                  myAccidental +
                  myOctaveToNum +
                  baseNote;
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

  final baseNote = 60;
  int positionToNum(NotePosition position) {
    if (position.note == Note.C) {
      return 0;
    } else if (position.note == Note.D) {
      return 2;
    } else if (position.note == Note.E) {
      return 4;
    } else if (position.note == Note.F) {
      return 5;
    } else if (position.note == Note.G) {
      return 7;
    } else if (position.note == Note.A) {
      return 9;
    } else if (position.note == Note.B) {
      return 11;
    } else {
      return 0;
    }
  }

  int acctidentalToNum(NotePosition position) {
    if (position.accidental == Accidental.Sharp) {
      return 1;
    } else {
      return 0;
    }
  }

  int octaveToNum(NotePosition position) {
    if (position.octave == 5) {
      return 12;
    } else if (position.octave == 6) {
      return 24;
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

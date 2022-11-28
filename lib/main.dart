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

  final String _value = 'assets/Yamaha-Grand-Lite-v2.0.sf2';

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        title: 'Piano Chord Trainer',
        home: CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(
            middle: Text('Piano Chord Trainer'),
          ),
          child: Center(
            child: InteractivePiano(
              hideNoteNames: true,
              highlightedNotes: [
                NotePosition(
                    note: Note.C, octave: 4, accidental: Accidental.None),
                NotePosition(
                    note: Note.E, octave: 4, accidental: Accidental.None),
                NotePosition(
                    note: Note.G, octave: 4, accidental: Accidental.None),
              ],
              naturalColor: Colors.white,
              accidentalColor: Colors.black,
              keyWidth: 80,
              noteRange: NoteRange.forClefs([
                Clef.Treble,
              ]),
              onNotePositionTapped: (position) {
                debugPrint('$position');
                int myPosition = SoundPlay.noteNum(position);
                debugPrint(myPosition.toString());
                _play(myPosition);
                // Use an audio library like flutter_midi to play the sound
              },
            ),
          ),
        ));
  }

  void _play(int midi) {
    _flutterMidi.playMidiNote(midi: midi);
  }
}

class SoundPlay {
  static int _positionToNum(NotePosition position) {
    switch (position.note) {
      case Note.C:
        return 0;
      case Note.D:
        return 2;
      case Note.E:
        return 4;
      case Note.F:
        return 5;
      case Note.G:
        return 7;
      case Note.A:
        return 9;
      case Note.B:
        return 11;
      default:
        return 0;
    }
  }

  static int _acctidentalToNum(NotePosition position) {
    if (position.accidental == Accidental.Sharp) {
      return 1;
    } else {
      return 0;
    }
  }

  static int _octaveToNum(NotePosition position) {
    return (position.octave + 1) * 12;
  }

  static int noteNum(NotePosition position) {
    return _positionToNum(position) +
        _acctidentalToNum(position) +
        _octaveToNum(position);
  }
}

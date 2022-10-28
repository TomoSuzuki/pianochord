import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:flutter/foundation.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterMidi = FlutterMidi();
  @override
  void initState() {
    if (!kIsWeb) {
      load(_value);
    } else {
      _flutterMidi.prepare(sf2: null);
    }
    super.initState();
  }

  void load(String asset) async {
    print('Loading File...');
    _flutterMidi.unmute();
    ByteData _byte = await rootBundle.load(asset);
    //assets/sf2/SmallTimGM6mb.sf2
    //assets/sf2/Piano.SF2
    _flutterMidi.prepare(sf2: _byte, name: _value.replaceAll('assets/', ''));
  }

  String _value = 'assets/Yamaha-Grand-Lite-v2.sf2';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // DropdownButton<String>(
            //   value: _value,
            //   items: [
            //     DropdownMenuItem(
            //       child: Text("Soft Piano"),
            //       value: "assets/sf2/SmallTimGM6mb.sf2",
            //     ),
            //     DropdownMenuItem(
            //       child: Text("Loud Piano"),
            //       value: "assets/sf2/Piano.SF2",
            //     ),
            //   ],
            //   onChanged: (String value) {
            //     setState(() {
            //       _value = value;
            //     });
            //     load(_value);
            //   },
            // ),
            ElevatedButton(
              child: Text('Play C'),
              onPressed: () {
                _play(60);
              },
            ),
            ElevatedButton(
              child: Text('Play D'),
              onPressed: () {
                _play(62);
              },
            ),
            ElevatedButton(
              child: Text('Play E'),
              onPressed: () {
                _play(64);
              },
            ),
            ElevatedButton(
              child: Text('Play F'),
              onPressed: () {
                _play(65);
              },
            ),
            ElevatedButton(
              child: Text('Play G'),
              onPressed: () {
                _play(67);
              },
            ),
            ElevatedButton(
              child: Text('Play A'),
              onPressed: () {
                _play(69);
              },
            ),
            ElevatedButton(
              child: Text('Play B'),
              onPressed: () {
                _play(71);
              },
            ),
            ElevatedButton(
              child: Text('Play C'),
              onPressed: () {
                _play(72);
              },
            ),
            ElevatedButton(
              child: Text('Chord C'),
              onPressed: () {
                _play(60);
                _play(64);
                _play(67);
              },
            ),
          ],
        )),
      ),
    );
  }

  void _play(int midi) {
    if (kIsWeb) {
      // WebMidi.play(midi);
    } else {
      _flutterMidi.playMidiNote(midi: midi);
    }
  }
}

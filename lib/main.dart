import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:flutter/foundation.dart';

//void main() => runApp(MyApp());
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
              child: Text('Chord C'),
              onPressed: () {
                _play(60);
                _play(64);
                _play(67);
              },
            ),
            ElevatedButton(
              child: Text('Chord G'),
              onPressed: () {
                _play(59);
                _play(62);
                _play(67);
              },
            ),
            const SizedBox(height: 20),
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

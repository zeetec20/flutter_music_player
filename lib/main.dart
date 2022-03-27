import 'package:fita_audio_player/models/Music.dart';
import 'package:fita_audio_player/pages/wrapper_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  Hive.registerAdapter<Music>(MusicAdapter());
  await Hive.initFlutter();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music Player',
        home: WrapperApp(),
      ),
    );
  }
}

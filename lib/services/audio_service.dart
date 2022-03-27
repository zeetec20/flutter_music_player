import 'dart:convert';

import 'package:fita_audio_player/main.dart';
import 'package:fita_audio_player/models/Music.dart';
import 'package:fita_audio_player/models/Music.dart';
import 'package:fita_audio_player/models/Artist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class AudioService {
  static Future<Box<Music>> getBox() => Hive.openBox<Music>('music_player');
  static Box<Music> musicPlayerBox = Hive.box<Music>('music_player');

  static Future<List<Music>> search(String keyword) async {
    keyword = keyword.replaceAll(' ', '+').toLowerCase();
    Uri url = Uri.parse(
        "https://itunes.apple.com/search?term=$keyword&entity=musicTrack");
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      Map musics = json.decode(response.body);
      return List<Map>.from(musics['results']).map((e) {
        return Music(
            e['trackId'],
            e['artistName'],
            e['artworkUrl100'],
            e['previewUrl'],
            e['trackName'],
            e['trackTimeMillis'],
            e['artistViewUrl']);
      }).toList();
    }
    return [];
  }

  static Future<String?> getImageArtist(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    Document html = parse(response.body);
    String? image;
    try {
      List<Element> elements =
          html.getElementsByClassName('circular-artwork__artwork');
      List<Element> element = elements[0].getElementsByTagName('source');
      image = element[1].attributes['srcset']!;
      return image.split(', ').last.replaceAll(' 380w', '');
    } catch (e) {}
    return image;
  }

  static Future<List<Artist>> getPopularArtist() async {
    String response = await rootBundle.loadString('assets/db.json');
    return List<Map>.from((await json.decode(response))['popular_artist'])
        .map((p) => Artist(p['name'], p['url']))
        .toList();
  }

  static Future<MusicResponse> save(Music music) async {
    Box<Music> box = await getBox();
    if (box.values.toList().where((m) => m.id == music.id).isEmpty) {
      await box.add(music);
      return MusicResponse.success;
    }
    return MusicResponse.music_exist;
  }

  static Future<List<Music>> getSavedMusic() async {
    Box<Music> box = await getBox();
    return box.values.toList();
  }

  static Future<ValueListenable<Box<Music>>> streamSavedMusic() async {
    await getBox();
    return musicPlayerBox.listenable();
  }

  static Future<bool> checkSavedMusic(Music music) async {
    Box<Music> box = await getBox();
    return box.values.where((m) => m.id == music.id).isNotEmpty;
  }

  static Future remove(Music music) async {
    Box<Music> box = await getBox();
    int id = box.values
        .toList()
        .asMap()
        .entries
        .where((m) => m.value.id == music.id)
        .first
        .key;
    await box.deleteAt(id);
  }
}

enum MusicResponse {
  success,
  music_exist,
}

import 'package:fita_audio_player/models/Music.dart';
import 'package:fita_audio_player/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

enum SourceMusic { popularArtist, search, library }

class AudioProvider with ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlayed = false;
  bool isPaused = false;
  String? cover;
  String? title;
  String? artist;
  String? artistUrl;
  int? trackTimeMillis;
  Music? music;
  List<Music>? listMusic;
  bool loadingLibrary = false;
  SourceMusic? sourceMusic;

  Future pause() async {
    this.isPaused = true;
    this.isPlayed = false;
    await audioPlayer.pause();

    notifyListeners();
  }

  Future play() async {
    this.isPlayed = true;
    this.isPaused = false;
    audioPlayer.play();

    notifyListeners();
  }

  Future playSource(
      Music music, List<Music> listMusic, SourceMusic source) async {
    this.music = music;
    this.cover = music.cover;
    this.title = music.title;
    this.artist = music.artist;
    this.artistUrl = music.artistUrl;
    this.trackTimeMillis = music.trackTimeMillis;
    this.listMusic = listMusic;
    this.isPaused = false;
    this.isPlayed = true;
    this.sourceMusic = source;

    await audioPlayer.setUrl(music.url);
    audioPlayer.play();

    notifyListeners();
  }

  Future seek(Duration time) async {
    await audioPlayer.seek(time);
  }

  Future addToLibrary() async {
    this.loadingLibrary = true;
    notifyListeners();
    await AudioService.save(this.music!);
    this.loadingLibrary = false;
    notifyListeners();
  }

  Future next() async {
    List<int?> listIndexMusic = this
        .listMusic!
        .asMap()
        .entries
        .map((m) => m.value.id == this.music!.id ? m.key : null)
        .toList()
        .cast<int?>();
    listIndexMusic.removeWhere((element) => element == null);
    Music music = this.listMusic![
        (listIndexMusic.first! + 1) > (this.listMusic!.length - 1)
            ? (listIndexMusic.length - 1)
            : (listIndexMusic.first! + 1)];
    await this.playSource(music, this.listMusic!, this.sourceMusic!);
  }

  Future previous() async {
    List<int?> listIndexMusic = this
        .listMusic!
        .asMap()
        .entries
        .map((m) => m.value.id == this.music!.id ? m.key : null)
        .toList()
        .cast<int?>();
    listIndexMusic.removeWhere((element) => element == null);
    Music music = this.listMusic![
        (listIndexMusic.first! - 1) < 0 ? 0 : (listIndexMusic.first! - 1)];
    await this.playSource(music, this.listMusic!, this.sourceMusic!);
  }

  clean() async {
    await this.audioPlayer.pause();
    this.isPlayed = false;
    this.isPaused = false;
    this.cover = null;
    this.title = null;
    this.artist = null;
    this.artistUrl = null;
    this.trackTimeMillis = null;
    this.music = null;
    this.listMusic = null;
    this.loadingLibrary = false;

    notifyListeners();
  }

  removeMusic(Music music) async {
    if (this.music!.id == music.id) await this.next();
    this.listMusic = this.listMusic!.where((m) => m.id != music.id).toList();

    notifyListeners();
  }
}

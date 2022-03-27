import 'package:fita_audio_player/models/Music.dart';
import 'package:fita_audio_player/services/audio_service.dart';
import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  String? keyword;
  List<Music>? search;
  bool loadingSearch = false;

  Future searchMusic(String keyword) async {
    this.loadingSearch = true;
    notifyListeners();
    this.search = await AudioService.search(keyword);
    this.loadingSearch = false;
    notifyListeners();
  }

  onChangeSearch(String keyword) {
    this.keyword = keyword;

    notifyListeners();
  }
}

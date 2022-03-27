import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  int page = 0;

  changePage(int page) {
    this.page = page;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class IndexProvider extends ChangeNotifier {
  int indexCurrent = 0;

  int get getIndexCurrent => indexCurrent;

  extendImagePageChanged(int index) {
    indexCurrent = index;

    notifyListeners();
  }
}

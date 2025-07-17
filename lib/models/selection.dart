import 'package:doxfood/api.dart';
import 'package:flutter/foundation.dart';

class SelectionModel extends ChangeNotifier {
  PlaceInfo? _selected;

  SelectionModel({PlaceInfo? selected}) : _selected = selected;

  PlaceInfo? get selected => _selected;

  set selected(PlaceInfo? place) {
    _selected = place;
    notifyListeners();
  }
}

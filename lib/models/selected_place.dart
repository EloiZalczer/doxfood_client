import 'package:doxfood/api.dart';
import 'package:flutter/foundation.dart';

class SelectedPlaceModel extends ChangeNotifier {
  PlaceInfo? _selected;

  SelectedPlaceModel({PlaceInfo? selected}) : _selected = selected;

  PlaceInfo? get selected => _selected;

  set selected(PlaceInfo? place) {
    _selected = place;
    notifyListeners();
  }
}

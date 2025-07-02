import 'dart:collection';

import 'package:doxfood/api.dart';
import 'package:flutter/foundation.dart';

import 'package:pocketbase/pocketbase.dart';

class PlaceTypesModel extends ChangeNotifier {
  final List<PlaceType> _placeTypes = [];

  final API _api;

  UnmodifiableListView<PlaceType> get placeTypes => UnmodifiableListView(_placeTypes);

  PlaceTypesModel({required API api}) : _api = api {
    _loadPlaceTypes();
  }

  Future<void> _loadPlaceTypes() async {
    _placeTypes.clear();
    _placeTypes.addAll((await _api.getPlaceTypes()));

    _api.pb.collection("place_types").subscribe("*", _onUpdate);

    notifyListeners();
  }

  void _onUpdate(RecordSubscriptionEvent e) {
    if (e.action == "create") {
      _placeTypes.add(PlaceType.fromRecord(e.record!));
    } else if (e.action == "update") {
      var index = _placeTypes.indexWhere((tag) => tag.id == e.record!.get<String>("id"));
      _placeTypes[index] = PlaceType.fromRecord(e.record!);
    } else if (e.action == "delete") {
      var index = _placeTypes.indexWhere((tag) => tag.id == e.record!.get<String>("id"));
      _placeTypes.removeAt(index);
    }
    notifyListeners();
  }

  void create(PlaceType tag) {
    _placeTypes.add(tag);
    notifyListeners();
  }
}

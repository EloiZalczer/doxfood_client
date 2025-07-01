import 'dart:collection';

import 'package:doxfood/api.dart';
import 'package:flutter/foundation.dart';

import 'package:pocketbase/pocketbase.dart';

class PlacesModel extends ChangeNotifier {
  final List<Place> _places = [];

  final API _api;

  UnmodifiableListView<Place> get places => UnmodifiableListView(_places);

  PlacesModel({required API api}) : _api = api {
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    _places.clear();
    _places.addAll((await _api.getPlaces()));

    _api.pb.collection("places").subscribe("*", expand: "tags,reviews_via_place.rating,type", _onUpdate);

    notifyListeners();
  }

  void _onUpdate(RecordSubscriptionEvent e) {
    if (e.action == "create") {
      _places.add(Place.fromRecord(e.record!));
    } else if (e.action == "update") {
      var index = _places.indexWhere((place) => place.id == e.record!.get<String>("id"));
      _places[index] = Place.fromRecord(e.record!);
    } else if (e.action == "delete") {
      var index = _places.indexWhere((place) => place.id == e.record!.get<String>("id"));
      _places.removeAt(index);
    }
    notifyListeners();
  }

  void create(Place place) {
    _places.add(place);
    notifyListeners();
  }

  Future<List<Review>> getPlaceReviews(placeId) async {
    return await _api.getReviews(placeId);
  }

  String getCurrentUserId() {
    return _api.pb.authStore.record!.get<String>("id");
  }
}

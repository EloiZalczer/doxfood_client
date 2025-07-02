import 'dart:collection';

import 'package:doxfood/api.dart';
import 'package:flutter/foundation.dart';

import 'package:pocketbase/pocketbase.dart';

class PlacesModel extends ChangeNotifier {
  final List<PlaceInfo> _places = [];

  final API _api;

  UnmodifiableListView<PlaceInfo> get places => UnmodifiableListView(_places);

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
      _places.add(PlaceInfo.fromRecord(e.record!));
    } else if (e.action == "update") {
      var index = _places.indexWhere((place) => place.id == e.record!.get<String>("id"));
      _places[index] = PlaceInfo.fromRecord(e.record!);
    } else if (e.action == "delete") {
      var index = _places.indexWhere((place) => place.id == e.record!.get<String>("id"));
      _places.removeAt(index);
    }
    notifyListeners();
  }

  Future<void> create(Place place) async {
    await _api.pb.collection("places").create(body: place.toRecord());
  }

  Future<List<Review>> getPlaceReviews(placeId) async {
    return await _api.getReviews(placeId);
  }

  Future createReview(placeId, Review review) async {
    print({"place": placeId, ...review.toRecord()});

    await _api.pb.collection("reviews").create(body: {"place": placeId, ...review.toRecord()});

    notifyListeners();
  }

  String getCurrentUserId() {
    return _api.pb.authStore.record!.get<String>("id");
  }
}

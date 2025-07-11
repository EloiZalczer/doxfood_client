import 'dart:collection';

import 'package:doxfood/api.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

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

  Future<void> createPlace({
    required String name,
    required LatLng location,
    required String price,
    required List<String> tags,
    required String type,
    String? googleMapsLink,
    String? description,
  }) async {
    await _api.pb
        .collection("places")
        .create(
          body: {
            "name": name,
            "location": {"lat": location.latitude, "lon": location.longitude},
            "price": price,
            "tags": tags,
            "type": type,
            "googleMapsLink": googleMapsLink,
            "description": description,
          },
        );
  }

  Future<List<Review>> getPlaceReviews(placeId, {Sort? sort}) async {
    return await _api.getReviews(placeId, sort: sort);
  }

  Future<void> createReview(String placeId, int rating, String text) async {
    await _api.pb
        .collection("reviews")
        .create(body: {"place": placeId, "user": _api.getCurrentUserId(), "rating": rating, "text": text});

    final updated = await _api.pb
        .collection("places")
        .getOne(
          placeId,
          expand: "tags,reviews_via_place",
          fields: "id, name, location, price, type, expand.tags, expand.reviews_via_place.rating",
        );

    var index = _places.indexWhere((place) => place.id == updated.get<String>("id"));
    _places[index] = PlaceInfo.fromRecord(updated);

    notifyListeners();
  }
}

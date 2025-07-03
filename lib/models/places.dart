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
    required List<Tag> tags,
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
            "tags": tags.map((tag) => tag.id).toList(),
            "type": type,
            "googleMapsLink": googleMapsLink,
            "description": description,
          },
        );
  }

  Future<List<Review>> getPlaceReviews(placeId) async {
    return await _api.getReviews(placeId);
  }

  Future<void> createReview(String placeId, int rating, String text) async {
    await _api.pb
        .collection("reviews")
        .create(body: {"place": placeId, "user": getCurrentUserId(), "rating": rating, "text": text});

    notifyListeners();
  }

  String getCurrentUserId() {
    return _api.pb.authStore.record!.get<String>("id");
  }
}

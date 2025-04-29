import 'dart:collection';

import 'package:doxfood/api.dart';
import 'package:flutter/foundation.dart';

import 'package:pocketbase/pocketbase.dart';

class PlacesModel extends ChangeNotifier {
  final String uri;
  final String username;
  final String password;
  final List<Place> _places = [];

  PlacesModel({
    required this.uri,
    required this.username,
    required this.password,
  });

  UnmodifiableListView<Place> get places => UnmodifiableListView(_places);

  Future<void> loadPlaces() async {
    var pb = await connect(uri, username, password);

    _places.clear();
    _places.addAll((await getPlaces(pb)));

    pb.collection("restaurants").subscribe(
      "*",
      expand: "tags,reviews_via_restaurant",
      (e) {
        if (e.action == "create") {
          _places.add(Place.fromRecord(e.record!));
        } else if (e.action == "update") {
          var index = _places.indexWhere(
            (place) => place.id == e.record!.get<String>("id"),
          );
          _places[index] = Place.fromRecord(e.record!);
        } else if (e.action == "delete") {
          var index = _places.indexWhere(
            (place) => place.id == e.record!.get<String>("id"),
          );
          _places.removeAt(index);
        }
        notifyListeners();
      },
    );

    notifyListeners();
  }

  void create(Place place) {
    _places.add(place);
    notifyListeners();
  }
}

class Place {
  Place({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.reviews,
    required this.tags,
  });

  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final List<Review> reviews;
  final List<String> tags;

  double get averageRating {
    return reviews.isNotEmpty
        ? reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length
        : 0;
  }

  factory Place.fromRecord(RecordModel record) {
    return Place(
      id: record.get<String>("id"),
      name: record.get<String>("name"),
      latitude: record.get<double>("latitude"),
      longitude: record.get<double>("longitude"),
      tags:
          record
              .get<List<RecordModel>>("expand.tags")
              .map((tag) => tag.get<String>("name"))
              .toList(),
      reviews:
          record
              .get<List<RecordModel>>("expand.reviews_via_restaurant")
              .map((review) => Review.fromRecord(review))
              .toList(),
    );
  }
}

class Review {
  Review({required this.text, required this.rating});

  final String text;
  final int rating;

  factory Review.fromRecord(RecordModel record) {
    return Review(
      text: record.get<String>("text"),
      rating: record.get<int>("rating"),
    );
  }
}

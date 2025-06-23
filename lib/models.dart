import 'dart:collection';

import 'package:doxfood/api.dart';
import 'package:doxfood/database.dart';
import 'package:flutter/foundation.dart';

import 'package:pocketbase/pocketbase.dart';

class PlacesModel extends ChangeNotifier {
  final List<Place> _places = [];

  PocketBase? _pb;

  UnmodifiableListView<Place> get places => UnmodifiableListView(_places);

  Future<void> reconnect(Server server) async {
    _pb = await connectWithToken(server.uri, server.token);
    _loadPlaces();
  }

  Future<void> connect(Server server, String username, String password) async {
    _pb = await connectWithPassword(server.uri, username, password);
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    _places.clear();
    _places.addAll((await getPlaces(_pb!)));

    _pb!.collection("restaurants").subscribe(
      "*",
      expand: "tags,reviews_via_restaurant.rating",
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

  Future<List<Review>> getPlaceReviews(placeId) async {
    return await getReviews(_pb!, placeId);
  }
}

class Place {
  Place({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.price,
    required this.ratings,
    required this.tags,
  });

  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String price;
  final List<int> ratings;
  final List<String> tags;

  double get averageRating {
    return ratings.isNotEmpty
        ? ratings.reduce((a, b) => a + b) / ratings.length
        : 0;
  }

  factory Place.fromRecord(RecordModel record) {
    return Place(
      id: record.get<String>("id"),
      name: record.get<String>("name"),
      latitude: record.get<double>("latitude"),
      longitude: record.get<double>("longitude"),
      price: record.get<String>("price"),
      tags:
          record
              .get<List<RecordModel>>("expand.tags")
              .map((tag) => tag.get<String>("name"))
              .toList(),
      ratings:
          record
              .get<List<RecordModel>>("expand.reviews_via_restaurant")
              .map((review) => review.get<int>("rating"))
              .toList(),
    );
  }

  @override
  String toString() {
    return "Place(id=$id, name=$name, latitude=$latitude, longitude=$longitude, price=$price, ratings=$ratings, tags=$tags)";
  }
}

class Review {
  Review({required this.text, required this.rating, required this.user});

  final String text;
  final int rating;
  final User user;

  factory Review.fromRecord(RecordModel record) {
    return Review(
      text: record.get<String>("text"),
      rating: record.get<int>("rating"),
      user: User.fromRecord(record.get<RecordModel>("expand.user")),
    );
  }

  @override
  String toString() {
    return "Review(text=$text, rating=$rating, user=$user)";
  }
}

class User {
  User({required this.id, required this.username});

  final String id;
  final String username;

  factory User.fromRecord(RecordModel record) {
    return User(
      id: record.get<String>("id"),
      username: record.get<String>("username"),
    );
  }

  @override
  String toString() {
    return "User(id=$id, username=$username)";
  }
}

class ServersListModel extends ChangeNotifier {
  final List<Server> _servers = [];

  UnmodifiableListView<Server> get servers => UnmodifiableListView(_servers);

  void add(Server server) {
    _servers.add(server);
    notifyListeners();
  }

  void remove(Server server) {
    _servers.remove(server);
    notifyListeners();
  }
}

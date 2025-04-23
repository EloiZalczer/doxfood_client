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

    notifyListeners();
  }

  void create(Place place) {
    _places.add(place);
    notifyListeners();
  }
}

class Place {
  Place({required this.name, required this.latitude, required this.longitude});

  final String name;
  final double latitude;
  final double longitude;

  factory Place.fromRecord(RecordModel record) {
    return Place(
      name: record.get<String>("name"),
      latitude: record.get<double>("latitude"),
      longitude: record.get<double>("longitude"),
    );
  }
}

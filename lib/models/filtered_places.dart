import 'dart:collection';

import 'package:doxfood/api.dart';
import 'package:doxfood/filtering.dart';
import 'package:doxfood/models/places.dart';
import 'package:flutter/material.dart';

class FilteredPlacesModel extends ChangeNotifier {
  List<PlaceInfo>? _places;

  final PlacesModel _source;

  PlaceType? _filteredPlaceType;

  PlaceType? get filteredPlaceType => _filteredPlaceType;

  set filteredPlaceType(PlaceType? placeType) {
    _filteredPlaceType = placeType;
    _refreshFilters();
  }

  UnmodifiableListView<PlaceInfo> get places {
    return (_places == null) ? _source.places : UnmodifiableListView(_places!);
  }

  void _onPlacesUpdated() {
    _refreshFilters();
  }

  FilteredPlacesModel(PlacesModel source) : _source = source {
    _source.addListener(_onPlacesUpdated);
  }

  @override
  void dispose() {
    super.dispose();
    _source.removeListener(_onPlacesUpdated);
  }

  void _refreshFilters() {
    final filters = [];

    if (_filteredPlaceType != null) {
      filters.add((Map place) => filterPlaces("type", null, [_filteredPlaceType!.id], false, place));
    }

    if (filters.isEmpty) {
      _places = null;
      notifyListeners();
      return;
    }

    _places =
        _source.places.where((p) {
          final m = p.place.asMap();
          for (var filter in filters) {
            if (!filter(m)) {
              return false;
            }
          }
          return true;
        }).toList();

    notifyListeners();
  }
}

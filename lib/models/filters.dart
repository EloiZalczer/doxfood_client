import 'dart:collection';

import 'package:doxfood/api.dart';
import 'package:flutter/foundation.dart';

import 'package:pocketbase/pocketbase.dart';

class FiltersModel extends ChangeNotifier {
  final List<Filter> _filters = [];

  final API _api;

  UnmodifiableListView<Filter> get filters => UnmodifiableListView(_filters);

  FiltersModel({required API api}) : _api = api {
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    _filters.clear();
    _filters.addAll((await _api.getFilters()));

    _api.pb.collection("filters").subscribe("*", _onUpdate);

    notifyListeners();
  }

  void _onUpdate(RecordSubscriptionEvent e) {
    if (e.action == "create") {
      _filters.add(Filter.fromRecord(e.record!));
    } else if (e.action == "update") {
      var index = _filters.indexWhere((filter) => filter.id == e.record!.get<String>("id"));
      _filters[index] = Filter.fromRecord(e.record!);
    } else if (e.action == "delete") {
      var index = _filters.indexWhere((filter) => filter.id == e.record!.get<String>("id"));
      _filters.removeAt(index);
    }
    notifyListeners();
  }

  Future<void> save(
    ID? id,
    String name,
    bool priceRangeEnabled,
    bool includeTagsEnabled,
    bool excludeTagsEnabled,
    bool includePlacesEnabled,
    bool excludePlacesEnabled,
    ID placeType,
    String lowerPriceBound,
    String upperPriceBound,
    List<ID> includedTags,
    List<ID> excludedTags,
    List<ID> includedPlaces,
    List<ID> excludedPlaces,
  ) async {
    Map<String, dynamic> body = {
      "name": name,
      "user": _api.pb.authStore.record!.get<String>("id"),
      "priceRangeEnabled": priceRangeEnabled,
      "includeTagsEnabled": includeTagsEnabled,
      "excludeTagsEnabled": excludeTagsEnabled,
      "includePlacesEnabled": includePlacesEnabled,
      "excludePlacesEnabled": excludePlacesEnabled,
      "placeType": placeType,
      "lowerPriceBound": lowerPriceBound,
      "upperPriceBound": upperPriceBound,
      "includedTags": includedTags,
      "excludedTags": excludedTags,
      "includedPlaces": includedPlaces,
      "excludedPlaces": excludedPlaces,
    };

    if (id == null) {
      await _api.pb.collection("filters").create(body: body);
    } else {
      await _api.pb.collection("filters").update(id, body: body);
    }
  }

  Future<void> delete(ID id) async {
    await _api.pb.collection("filters").delete(id);
  }
}

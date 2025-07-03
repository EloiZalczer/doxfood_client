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

  Future<void> create(PlaceType placeType, String name) async {
    await _api.pb.collection("filters").create(body: {"name": name, "place_type": placeType.id});
  }
}

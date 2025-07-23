import 'dart:collection';

import 'package:doxfood/api.dart';
import 'package:doxfood/widgets/filter_editor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RandomConfigurationModel extends ChangeNotifier {
  int? _server;
  FilterConfiguration? _quickFilter;
  Set<ID> _selectedFilters = {};
  String? _selectedFiltering;

  RandomConfigurationModel._();

  static Future<RandomConfigurationModel> open() async {
    // WidgetsFlutterBinding.ensureInitialized();

    // final db = await openDatabase(
    //   join(await getDatabasesPath(), "doxfood_database.db"),
    //   onCreate: (db, version) {
    //     return db.execute("CREATE TABLE random_config(id INTEGER PRIMARY KEY, server TEXT UNIQUE)");
    //   },
    //   version: 1,
    // );

    return RandomConfigurationModel._();
  }

  Future<void> load(int server) async {
    _server = server;
    _quickFilter = null;
    _selectedFilters = {};
    _selectedFiltering = "no_filter";
  }

  UnmodifiableListView<ID> get selectedFilters => UnmodifiableListView(_selectedFilters);
  String? get selectedFiltering => _selectedFiltering;
  FilterConfiguration? get quickFilter => _quickFilter;

  void setFilterSelected(ID filter, bool selected) {
    if (selected) {
      if (_selectedFilters.contains(filter)) return;
      _selectedFilters.add(filter);
    }

    if (!selected) {
      if (!_selectedFilters.contains(filter)) return;
      _selectedFilters.remove(filter);
    }

    notifyListeners();
  }

  set selectedFiltering(String? filtering) {
    _selectedFiltering = filtering;
    notifyListeners();
  }

  set quickFilter(FilterConfiguration? configuration) {
    _quickFilter = configuration;
    notifyListeners();
  }
}

import 'dart:collection';

import 'package:flutter/material.dart';

class MultipleSelectionController extends ChangeNotifier {
  final Set<String> _selected = {};

  MultipleSelectionController({Iterable<String>? selected}) {
    if (selected != null) _selected.addAll(selected);
  }

  Set<String> get selected => UnmodifiableSetView(_selected);

  bool isSelected(String id) {
    return _selected.contains(id);
  }

  void select(String id) {
    _selected.add(id);
    notifyListeners();
  }

  void deselect(String id) {
    _selected.remove(id);
    notifyListeners();
  }

  void toggle(String id) {
    if (_selected.contains(id)) {
      _selected.remove(id);
    } else {
      _selected.add(id);
    }
    notifyListeners();
  }

  void setSelected(String id, bool selected) {
    if (selected) {
      select(id);
    } else {
      deselect(id);
    }
  }
}

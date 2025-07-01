import 'dart:collection';

import 'package:doxfood/api.dart';
import 'package:flutter/foundation.dart';

import 'package:pocketbase/pocketbase.dart';

class TagsModel extends ChangeNotifier {
  final List<Tag> _tags = [];

  final API _api;

  UnmodifiableListView<Tag> get tags => UnmodifiableListView(_tags);

  TagsModel({required API api}) : _api = api {
    _loadTags();
  }

  Future<void> _loadTags() async {
    _tags.clear();
    _tags.addAll((await _api.getTags()));

    _api.pb.collection("tags").subscribe("*", _onUpdate);

    notifyListeners();
  }

  void _onUpdate(RecordSubscriptionEvent e) {
    if (e.action == "create") {
      _tags.add(Tag.fromRecord(e.record!));
    } else if (e.action == "update") {
      var index = _tags.indexWhere((tag) => tag.id == e.record!.get<String>("id"));
      _tags[index] = Tag.fromRecord(e.record!);
    } else if (e.action == "delete") {
      var index = _tags.indexWhere((tag) => tag.id == e.record!.get<String>("id"));
      _tags.removeAt(index);
    }
    notifyListeners();
  }

  void create(Tag tag) {
    _tags.add(tag);
    notifyListeners();
  }
}

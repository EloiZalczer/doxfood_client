import 'dart:async';

import 'package:doxfood/api.dart';

class PlaceSelectionController {
  final StreamController<PlaceInfo?> _controller = StreamController<PlaceInfo?>();

  Stream<PlaceInfo?> get stream => _controller.stream;

  void select(PlaceInfo? place) {
    _controller.add(place);
  }
}

import 'dart:async';

import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

enum LocationStatus { initializing, disabled, denied, running, deniedForever }

class LocationModel {
  late Stream<LocationMarkerPosition?> positionStream;
  late Stream<LocationMarkerHeading?> headingStream;

  LocationMarkerPosition? _current;

  LocationMarkerPosition? get current => _current;

  late StreamSubscription<LocationMarkerPosition?>? _positionStreamSubscription;

  Future<void> init() async {
    positionStream = const LocationMarkerDataStreamFactory().fromGeolocatorPositionStream();
    headingStream = const LocationMarkerDataStreamFactory().fromRotationSensorHeadingStream();

    _positionStreamSubscription = positionStream.listen(
      (position) => _current = position,
      onError: (error) {
        _positionStreamSubscription?.cancel();
      },
    );
  }
}

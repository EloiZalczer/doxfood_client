import 'dart:math';

import 'package:latlong2/latlong.dart';

const _r = 6371;
const _p = pi / 180;

double distanceBetween(LatLng loc1, LatLng loc2) {
  // from https://stackoverflow.com/a/21623206

  final a =
      0.5 -
      cos((loc1.latitude - loc2.latitude) * _p) / 2 +
      cos(loc1.latitude * _p) * cos(loc2.latitude * _p) * (1 - cos((loc1.longitude - loc2.longitude) * _p)) / 2;
  return 2 * _r * asin(sqrt(a));
}

import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

void launchMap(LatLng location, String name) async {
  try {
    final url = Uri.parse(
      'geo:${location.latitude},${location.longitude}?q=${location.latitude},${location.longitude}($name)',
    );
    await launchUrl(url);
  } catch (error) {
    return;
  }
}

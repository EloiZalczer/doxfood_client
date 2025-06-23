import 'package:doxfood/models.dart';
import 'package:doxfood/pages/map/marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatelessWidget {
  final Function onMapTapped;
  final Function onPlaceTapped;

  const MapWidget({
    super.key,
    required this.onMapTapped,
    required this.onPlaceTapped,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
        maxZoom: 20,
        minZoom: 8,
        keepAlive: true,
        interactionOptions: InteractionOptions(rotationThreshold: 0),
        initialCenter: const LatLng(
          48.8363012,
          2.240709935,
        ), // TODO don't hardcode that
        onTap: (tapPosition, point) {
          onMapTapped(context, tapPosition, point);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: "com.doxfood.app",
        ),
        Consumer<PlacesModel>(
          builder: (context, model, child) {
            return MarkerLayer(
              markers:
                  model.places.map((place) {
                    return Marker(
                      point: LatLng(place.latitude, place.longitude),
                      child: PlaceMarker(
                        place: place,
                        onTap: () => onPlaceTapped(place),
                        child: FlutterLogo(),
                      ),
                    );
                  }).toList(),
            );
          },
        ),
      ],
    );
  }
}

import 'package:doxfood/api.dart';
import 'package:doxfood/models/places.dart';
import 'package:doxfood/widgets/marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

typedef MapBuilder = void Function(BuildContext context, void Function(PlaceInfo place) onPlaceSelected);

class MapWidget extends StatefulWidget {
  final Function onMapTapped;
  final Function onPlaceTapped;
  final MapBuilder builder;

  const MapWidget({super.key, required this.onMapTapped, required this.onPlaceTapped, required this.builder});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapController _mapController = MapController();

  void centerMapOnPlace(PlaceInfo place) {
    _mapController.move(place.location, _mapController.camera.zoom);
  }

  @override
  Widget build(BuildContext context) {
    widget.builder.call(context, centerMapOnPlace);

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        maxZoom: 20,
        minZoom: 8,
        keepAlive: true,
        interactionOptions: InteractionOptions(rotationThreshold: 0),
        initialCenter: const LatLng(48.8363012, 2.240709935), // TODO don't hardcode that
        onTap: (tapPosition, point) {
          widget.onMapTapped(context, tapPosition, point);
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
                  model.places.map((PlaceInfo place) {
                    return Marker(
                      width: 20,
                      height: 20,
                      point: place.location,
                      child: PlaceMarker(place: place.place, onTap: () => widget.onPlaceTapped(place)),
                    );
                  }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

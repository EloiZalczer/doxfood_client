import 'package:doxfood/api.dart';
import 'package:doxfood/models/filtered_places.dart';
import 'package:doxfood/models/location.dart';
import 'package:doxfood/models/selected_place.dart';
import 'package:doxfood/widgets/compass.dart';
import 'package:doxfood/widgets/marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';

class MapWidget extends StatefulWidget {
  final MapController? controller;
  final Function onMapTapped;
  final Function onPlaceTapped;

  const MapWidget({super.key, this.controller, required this.onMapTapped, required this.onPlaceTapped});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late final MapController _mapController = widget.controller ?? MapController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            maxZoom: 20,
            minZoom: 8,
            keepAlive: true,
            interactionOptions: const InteractionOptions(),
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
            Consumer2<FilteredPlacesModel, SelectedPlaceModel>(
              builder: (context, places, selection, child) {
                return MarkerLayer(
                  markers:
                      places.places.map((PlaceInfo place) {
                        return Marker(
                          width: 20,
                          height: 20,
                          point: place.location,
                          child: PlaceMarker(
                            place: place.place,
                            onTap: () => widget.onPlaceTapped(place),
                            selected: selection.selected == place,
                          ),
                        );
                      }).toList(),
                );
              },
            ),
            Consumer<LocationModel>(
              builder: (context, value, child) {
                return CurrentLocationLayer(positionStream: value.positionStream, headingStream: value.headingStream);
              },
            ),
            const MapCompass(icon: Compass(), hideIfRotatedNorth: true, padding: EdgeInsets.only(top: 130, right: 10)),
          ],
        ),
      ],
    );
  }
}

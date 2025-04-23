import 'package:doxfood/dialogs/add_place.dart';
import 'package:doxfood/pages/map/panel.dart';
import 'package:doxfood/pages/map/search.dart';
import 'package:doxfood/pages/map/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final panelController = PanelController();
  final expansionTileController = ExpansionTileController();

  void onMapTapped(
    BuildContext context,
    TapPosition tapPosition,
    LatLng point,
  ) {
    if (expansionTileController.isExpanded) {
      expansionTileController.collapse();
    } else {
      AddPlaceDialog.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          SlidingUpPanel(
            controller: panelController,
            snapPoint: 0.5,
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            maxHeight: MediaQuery.of(context).size.height * 0.9,
            minHeight: MediaQuery.of(context).size.height * 0.15,
            panelBuilder:
                (controller) => PanelWidet(
                  controller: controller,
                  panelController: panelController,
                ),
            body: MapWidget(onMapTapped: onMapTapped),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.04,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: SearchWidget(
                    expansionTileController: expansionTileController,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

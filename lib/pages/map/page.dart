import 'package:doxfood/dialogs/add_place.dart';
import 'package:doxfood/models.dart';
import 'package:doxfood/pages/map/panel.dart';
import 'package:doxfood/pages/map/search_bar.dart';
import 'package:doxfood/pages/map/map.dart';
import 'package:doxfood/pages/map/menu_drawer.dart';
import 'package:doxfood/pages/servers/page.dart';
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

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final GlobalKey<State<PanelWidget>> _panelKey = GlobalKey();

  void onMapTapped(
    BuildContext context,
    TapPosition tapPosition,
    LatLng point,
  ) {
    if (panelController.isPanelOpen) {
      panelController.close();
    } else {
      AddPlaceDialog.show(context);
    }
  }

  late void Function(Place place) onPlaceTapped;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      endDrawer: SettingsDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          SlidingUpPanel(
            controller: panelController,
            snapPoint: 0.5,
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            maxHeight: MediaQuery.of(context).size.height * 0.75,
            minHeight: MediaQuery.of(context).size.height * 0.15,
            panelBuilder:
                (controller) => PanelWidget(
                  builder: (
                    BuildContext context,
                    void Function(Place place) openPlacePanel,
                  ) {
                    onPlaceTapped = openPlacePanel;
                  },
                  controller: controller,
                  panelController: panelController,
                ),
            body: MapWidget(
              key: _panelKey,
              onMapTapped: onMapTapped,
              onPlaceTapped: (Place p) {
                panelController.animatePanelToPosition(0.5);
                onPlaceTapped(p);
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.04,
            left: MediaQuery.of(context).size.width * 0.01,
            right: MediaQuery.of(context).size.width * 0.01,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(spreadRadius: 0.0, blurRadius: 2.0)],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ServersPage()),
                      );
                    },
                    icon: Icon(Icons.public),
                  ),
                ),
                Expanded(child: Center(child: SearchField())),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(spreadRadius: 0.0, blurRadius: 2.0)],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      _key.currentState!.openEndDrawer();
                    },
                    icon: Icon(Icons.menu),
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

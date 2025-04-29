import 'package:doxfood/dialogs/add_place.dart';
import 'package:doxfood/pages/map/panel.dart';
import 'package:doxfood/pages/map/search_bar.dart';
import 'package:doxfood/pages/map/map.dart';
import 'package:doxfood/pages/map/settings_drawer.dart';
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
  final expansionTileController = ExpansionTileController();

  final GlobalKey<ScaffoldState> _key = GlobalKey();

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
            maxHeight: MediaQuery.of(context).size.height * 0.8,
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
            left: MediaQuery.of(context).size.width * 0.01,
            right: MediaQuery.of(context).size.width * 0.01,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ServersPage()),
                    );
                  },
                  icon: Icon(Icons.public),
                ),
                Expanded(child: SearchField()),
                IconButton(
                  onPressed: () {
                    _key.currentState!.openEndDrawer();
                  },
                  icon: Icon(Icons.account_circle),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

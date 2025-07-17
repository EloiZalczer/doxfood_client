import 'package:doxfood/api.dart';
import 'package:doxfood/models/location.dart';
import 'package:doxfood/models/selection.dart';
import 'package:doxfood/pages/add_place.dart';
import 'package:doxfood/widgets/panel.dart';
import 'package:doxfood/widgets/search_bar.dart';
import 'package:doxfood/widgets/map.dart';
import 'package:doxfood/widgets/menu_drawer.dart';
import 'package:doxfood/pages/servers_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class PanelPositionModel extends ChangeNotifier {
  double _position;

  PanelPositionModel(this._position);

  double get position => _position;

  set position(double value) {
    _position = value;
    notifyListeners();
  }
}

class _MapPageState extends State<MapPage> {
  final panelController = PanelController();

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final GlobalKey<State<PanelWidget>> _panelKey = GlobalKey();

  final _mapController = MapController();

  late final panelHeightOpen = MediaQuery.of(context).size.height * 0.75;
  late final panelHeightClosed = MediaQuery.of(context).size.height * 0.15;

  late final PanelPositionModel _panelPositionModel = PanelPositionModel(0);

  @override
  void initState() {
    super.initState();
    context.read<SelectionModel>().addListener(_onPlaceSelectionChanged);
  }

  @override
  void dispose() {
    super.dispose();
    context.read<SelectionModel>().removeListener(_onPlaceSelectionChanged);
  }

  void _onPlaceSelectionChanged() {
    final place = context.read<SelectionModel>().selected;

    if (place != null) {
      _centerMapOnPlace(place);
    }
  }

  void _onMapTapped(BuildContext context, TapPosition tapPosition, LatLng point) {
    if (panelController.isPanelOpen) {
      panelController.close();
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPlacePage(point: point)));
    }
  }

  void _centerMapOnPlace(PlaceInfo place) {
    _mapController.move(place.location, _mapController.camera.zoom);
  }

  void _centerMapOnUser() {
    final location = context.read<LocationModel>().current;

    if (location != null) {
      _mapController.move(location.latLng, _mapController.camera.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.75;
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.15;

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
            maxHeight: panelHeightOpen,
            minHeight: panelHeightClosed,
            panelBuilder: (controller) => PanelWidget(controller: controller, panelController: panelController),
            body: MapWidget(
              controller: _mapController,
              key: _panelKey,
              onMapTapped: _onMapTapped,
              onPlaceTapped: (PlaceInfo place) {
                context.read<SelectionModel>().selected = place;
              },
            ),
            onPanelSlide: (position) => _panelPositionModel.position = position,
          ),
          ChangeNotifierProvider<PanelPositionModel>.value(
            value: _panelPositionModel,
            child: Consumer<PanelPositionModel>(
              builder: (context, value, child) {
                final bottom = value.position * (panelHeightOpen - panelHeightClosed) + 140;
                if (value.position < 0.8) {
                  return Positioned(
                    right: 20,
                    bottom: bottom,
                    child: FloatingActionButton(
                      onPressed: _centerMapOnUser,
                      backgroundColor: Colors.white,
                      shape: CircleBorder(side: BorderSide(color: Colors.grey)),
                      elevation: 1,
                      child: Icon(Icons.gps_not_fixed, color: Theme.of(context).primaryColor),
                    ),
                  );
                } else {
                  return Container();
                }
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ServersListPage()));
                    },
                    icon: Icon(Icons.public),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SearchField(
                      onPlaceSelected: (PlaceInfo place) {
                        context.read<SelectionModel>().selected = place;
                      },
                    ),
                  ),
                ),
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

import 'dart:math';

import 'package:doxfood/api.dart';
import 'package:doxfood/models/filtered_places.dart';
import 'package:doxfood/models/location.dart';
import 'package:doxfood/models/place_types.dart';
import 'package:doxfood/models/selection.dart';
import 'package:doxfood/pages/add_place.dart';
import 'package:doxfood/utils/icons.dart';
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

  late final panelHeightOpen = MediaQuery.of(context).size.height * 0.8;
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
    print("map tapped");
    if (panelController.isPanelOpen) {
      panelController.close();
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPlacePage(point: point)));
    }
  }

  void _centerMapOnPlace(PlaceInfo place) {
    // The panel slides up to half of the screen when selecting a place. Use an
    // offset to make sure the place is visible.

    _mapController.move(
      place.location,
      _mapController.camera.zoom,
      offset: Offset(0, -0.2 * MediaQuery.of(context).size.height),
    );
  }

  void _centerMapOnUser() {
    final location = context.read<LocationModel>().current;

    if (location != null) {
      _mapController.move(location.latLng, _mapController.camera.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      endDrawer: const SettingsDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          MapWidget(
            controller: _mapController,
            key: _panelKey,
            onMapTapped: _onMapTapped,
            onPlaceTapped: (PlaceInfo place) {
              context.read<SelectionModel>().selected = place;
            },
          ),
          ChangeNotifierProvider<PanelPositionModel>.value(
            value: _panelPositionModel,
            child: Consumer<PanelPositionModel>(
              builder: (context, value, child) {
                final bottom = min(value.position, 0.7) * (panelHeightOpen - panelHeightClosed) + 140;
                return Positioned(
                  right: 20,
                  bottom: bottom,
                  child: FloatingActionButton(
                    onPressed: _centerMapOnUser,
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(side: BorderSide(color: Colors.grey)),
                    elevation: 1,
                    child: Icon(Icons.gps_not_fixed, color: Theme.of(context).primaryColor),
                  ),
                );
              },
            ),
          ),
          SlidingUpPanel(
            controller: panelController,
            snapPoint: 0.5,
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            maxHeight: panelHeightOpen,
            minHeight: panelHeightClosed,
            panelBuilder: (controller) => PanelWidget(controller: controller, panelController: panelController),
            onPanelSlide: (position) => _panelPositionModel.position = position,
          ),
          ChangeNotifierProvider<PanelPositionModel>.value(
            value: _panelPositionModel,
            child: Consumer<PanelPositionModel>(
              builder: (context, value, child) {
                final b = MediaQuery.of(context).size.height * 0.04;
                final a = -b / 0.2;
                final x = (max(0.8, value.position) - 0.8) * 5;

                final top = a * x + b;

                return Positioned(
                  top: top,
                  left: MediaQuery.of(context).size.width * 0.01,
                  right: MediaQuery.of(context).size.width * 0.01,
                  child: const MapPageHeader(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MapPageHeader extends StatelessWidget {
  const MapPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(spreadRadius: 0.0, blurRadius: 2.0)],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ServersListPage()));
                },
                icon: const Icon(Icons.public),
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
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(spreadRadius: 0.0, blurRadius: 2.0)],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  // _key.currentState!.openEndDrawer(); // TODO re-implement this feature
                },
                icon: const Icon(Icons.menu),
              ),
            ),
          ],
        ),
        Consumer2<PlaceTypesModel, FilteredPlacesModel>(
          builder: (context, types, filtered, child) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                children: [
                  ...List.generate(types.placeTypes.length, (int index) {
                    final type = types.placeTypes[index];
                    return ChoiceChip(
                      backgroundColor: Colors.white,
                      label: Text(type.name),
                      selected: type.id == filtered.filteredPlaceType?.id,
                      onSelected: (value) {
                        if (value) {
                          filtered.filteredPlaceType = type;
                        } else if (filtered.filteredPlaceType == type) {
                          filtered.filteredPlaceType = null;
                        }
                      },
                      showCheckmark: false,
                      avatar: Icon(iconsMap[type.icon], color: Colors.black),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

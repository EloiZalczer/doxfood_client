import 'package:doxfood/api.dart';
import 'package:doxfood/models/places.dart';
import 'package:doxfood/widgets/place_panel.dart';
import 'package:doxfood/widgets/place_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

typedef PanelBuilder = void Function(BuildContext context, void Function(PlaceInfo place) openPlacePanel);

class PanelWidget extends StatefulWidget {
  final ScrollController controller;
  final PanelController panelController;
  final PanelBuilder builder;

  const PanelWidget({super.key, required this.controller, required this.panelController, required this.builder});

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  var navigatorKey = GlobalKey<NavigatorState>();

  void openPlacePanel(PlaceInfo place) {
    navigatorKey.currentState!.push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => PlacePanel(place: place),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  void togglePanel() {
    widget
            .panelController
            .isPanelOpen // FIXME why is the panel never open ??
        ? widget.panelController.close()
        : widget.panelController.open();
  }

  Widget buildDragHandle() {
    return GestureDetector(
      onTap: togglePanel,
      child: Center(
        child: Container(
          width: 30,
          height: 5,
          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.builder.call(context, openPlacePanel);

    return Column(
      children: [
        SizedBox(height: 12),
        buildDragHandle(),
        SizedBox(height: 12),
        Expanded(
          child: NavigatorPopHandler(
            onPopWithResult: (result) {
              navigatorKey.currentState?.maybePop();
            },
            child: Navigator(
              key: navigatorKey,
              onGenerateRoute: (routeSettings) {
                return MaterialPageRoute(
                  builder: (context) {
                    return Consumer<PlacesModel>(
                      builder: (context, model, child) {
                        return model.places.isNotEmpty
                            ? ListView.separated(
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              controller: widget.controller,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: model.places.length,
                              itemBuilder: (context, index) {
                                return PlaceTile(place: model.places[index]);
                              },
                            )
                            : Center(child: Text("No places"));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

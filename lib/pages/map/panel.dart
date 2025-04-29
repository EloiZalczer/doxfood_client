import 'package:doxfood/models.dart';
import 'package:doxfood/pages/map/place_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PanelWidet extends StatefulWidget {
  final ScrollController controller;
  final PanelController panelController;

  PanelWidet({
    super.key,
    required this.controller,
    required this.panelController,
  });

  @override
  State<PanelWidet> createState() => _PanelWidetState();
}

class _PanelWidetState extends State<PanelWidet> {
  var navigatorKey = GlobalKey<NavigatorState>();

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
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

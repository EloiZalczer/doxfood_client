import 'dart:async';

import 'package:doxfood/api.dart';
import 'package:doxfood/controllers/place_selection_controller.dart';
import 'package:doxfood/models/filtered_places.dart';
import 'package:doxfood/models/selected_place.dart';
import 'package:doxfood/pages/add_review.dart';
import 'package:doxfood/widgets/place_panel.dart';
import 'package:doxfood/widgets/place_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PanelWidget extends StatefulWidget {
  final ScrollController controller;
  final PanelController panelController;

  const PanelWidget({super.key, required this.controller, required this.panelController});

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  var navigatorKey = GlobalKey<NavigatorState>();
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = context.read<PlaceSelectionController>().stream.listen(_onPlaceSelected);
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  void _onPlaceSelected(PlaceInfo? place) {
    context.read<SelectedPlaceModel>().selected = place;

    if (place == null) return;

    if (widget.panelController.panelPosition < 0.5) {
      widget.panelController.animatePanelToSnapPoint();
    }

    navigatorKey.currentState!.push(
      PageRouteBuilder(
        settings: RouteSettings(
          name: "place",
          arguments: {"place": place},
        ), // Name the route so we can use this to pop all open places at once
        pageBuilder: (context, animation, secondaryAnimation) {
          return PlacePanel(
            place: place,
            onAddReview: (int rating) => _openAddReviewPage(place, rating),
            onClosePanel: _onClosePlacePanel,
          );
        },
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  void _onClosePlacePanel() {
    context.read<SelectedPlaceModel>().selected = null;
    navigatorKey.currentState!.popUntil((route) {
      if (route.settings.name == "place") return false;
      return true;
    });
  }

  void _openAddReviewPage(PlaceInfo place, int rating) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => AddReviewPage(rating: rating, place: place.place)));
  }

  void togglePanel() {
    widget.panelController.isPanelOpen ? widget.panelController.close() : widget.panelController.open();
  }

  Widget buildDragHandle() {
    return GestureDetector(
      onTap: togglePanel,
      child: Center(
        child: Container(
          width: 30,
          height: 5,
          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: const BorderRadius.all(Radius.circular(5))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        buildDragHandle(),
        const SizedBox(height: 12),
        Expanded(
          child: NavigatorPopHandler(
            onPopWithResult: (result) {
              navigatorKey.currentState?.maybePop();
            },
            child: Navigator(
              key: navigatorKey,
              observers: [CurrentPlaceObserver(context: context)],
              onGenerateRoute: (routeSettings) {
                return MaterialPageRoute(
                  builder: (context) {
                    return Consumer<FilteredPlacesModel>(
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
                                return PlaceTile(
                                  place: model.places[index],
                                  onPlaceTapped: (PlaceInfo place) {
                                    context.read<PlaceSelectionController>().select(place);
                                  },
                                );
                              },
                            )
                            : const Center(child: Text("No places. Create the first one by clicking on the map !"));
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

class CurrentPlaceObserver extends NavigatorObserver {
  final BuildContext context;

  CurrentPlaceObserver({required this.context});

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute == null || previousRoute.settings.arguments == null) {
      context.read<SelectedPlaceModel>().selected = null;
      return;
    }

    final place = (previousRoute.settings.arguments as Map)["place"];

    if (place == null) {
      context.read<SelectedPlaceModel>().selected = null;
      return;
    } else {}
    context.read<SelectedPlaceModel>().selected = place;

    super.didPop(route, previousRoute);
  }
}

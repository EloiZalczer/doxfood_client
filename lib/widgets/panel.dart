import 'package:doxfood/api.dart';
import 'package:doxfood/models/filtered_places.dart';
import 'package:doxfood/models/selection.dart';
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

    if (place == null) return;

    if (widget.panelController.panelPosition < 0.5) {
      widget.panelController.animatePanelToSnapPoint();
    }

    navigatorKey.currentState!.push(
      PageRouteBuilder(
        settings: const RouteSettings(name: "place"), // Name the route so we can use this to pop all open places at once
        pageBuilder: (context, animation, secondaryAnimation) {
          return PlacePanel(place: place, onAddReview: (int rating) => _openAddReviewPage(place, rating));
        },
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
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
                                    context.read<SelectionModel>().selected = place;
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

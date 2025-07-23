import 'package:doxfood/api.dart';
import 'package:doxfood/ext.dart';
import 'package:doxfood/models/location.dart';
import 'package:doxfood/models/place_types.dart';
import 'package:doxfood/models/selection.dart';
import 'package:doxfood/utils/distance.dart';
import 'package:doxfood/widgets/rating.dart';
import 'package:doxfood/widgets/reviews_panel.dart';
import 'package:doxfood/widgets/tag_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlacePanel extends StatefulWidget {
  final PlaceInfo place;
  final Function(int rating)? onAddReview;

  const PlacePanel({super.key, required this.place, this.onAddReview});

  @override
  State<PlacePanel> createState() => _PlacePanelState();
}

class _PlacePanelState extends State<PlacePanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Stack(
            children: [
              PlacePanelHeader(place: widget.place),
              Positioned(
                right: 60,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade300),
                  child: IconButton(
                    onPressed: () {
                      launchMap(widget.place.location, widget.place.name);
                    },
                    icon: const Icon(Icons.navigation),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade300),
                  child: IconButton(
                    onPressed: () {
                      context.read<SelectionModel>().selected = null;
                      Navigator.popUntil(context, (route) {
                        if (route.settings.name == "place") return false;
                        return true;
                      });
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.place.description != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text(widget.place.description!)]),
          ),
        const Divider(height: 10),
        Expanded(child: ReviewsPanel(place: widget.place, onAddReview: widget.onAddReview)),
      ],
    );
  }
}

class PlacePanelHeader extends StatelessWidget {
  final PlaceInfo place;

  const PlacePanelHeader({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final placeType = context.read<PlaceTypesModel>().getById(place.type);
    final location = context.read<LocationModel>().current;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(place.name, textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 25)),
        const SizedBox(height: 5),
        PlaceRatingWidget(place: place),
        Row(
          spacing: 8.0,
          children: [
            Text(placeType.name, style: TextStyle(color: Theme.of(context).hintColor)),
            Text("•", style: TextStyle(color: Theme.of(context).hintColor)),
            Text(place.price, style: TextStyle(color: Theme.of(context).hintColor)),
            if (location != null) ...[
              Text("•", style: TextStyle(color: Theme.of(context).hintColor)),
              Text(
                "${distanceBetween(location.latLng, place.location).toStringAsFixed(2)} km",
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            ],
          ],
        ),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 10,
          runSpacing: 10,
          children:
              place.tags.map((tag) {
                return TagChip(tag: tag);
              }).toList(),
        ),
      ],
    );
  }
}

import 'package:doxfood/api.dart';
import 'package:doxfood/models/location.dart';
import 'package:doxfood/models/place_types.dart';
import 'package:doxfood/utils/distance.dart';
import 'package:doxfood/widgets/rating.dart';
import 'package:doxfood/widgets/tag_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaceTile extends StatelessWidget {
  final PlaceInfo place;
  final Function(PlaceInfo place)? onPlaceTapped;

  const PlaceTile({super.key, required this.place, this.onPlaceTapped});

  @override
  Widget build(BuildContext context) {
    final PlaceTypesModel model = context.read<PlaceTypesModel>();
    final location = context.read<LocationModel>().current;

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(place.name, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0)),
            Row(
              spacing: 8.0,
              children: [
                PlaceRatingWidget(place: place, dense: true),
                Text("•", style: TextStyle(color: Theme.of(context).hintColor)),
                Text(place.price, style: TextStyle(color: Theme.of(context).hintColor)),
                Text("•", style: TextStyle(color: Theme.of(context).hintColor)),
                Text(model.getById(place.type).name, style: TextStyle(color: Theme.of(context).hintColor)),
                if (location != null) ...[
                  Text("•", style: TextStyle(color: Theme.of(context).hintColor)),
                  Text(
                    "${distanceBetween(location.latLng, place.location).toStringAsFixed(2)} km",
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                ],
              ],
            ),
            SizedBox(height: 5.0),
            Row(
              children: [
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 10,
                  children:
                      place.tags.map((tag) {
                        return TagChip(tag: tag);
                      }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        if (onPlaceTapped != null) onPlaceTapped!(place);
      },
    );
  }
}

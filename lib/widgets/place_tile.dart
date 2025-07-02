import 'package:doxfood/api.dart';
import 'package:doxfood/widgets/place_panel.dart';
import 'package:doxfood/widgets/rating.dart';
import 'package:doxfood/utils/color.dart';
import 'package:flutter/material.dart';

class PlaceTile extends StatelessWidget {
  final PlaceInfo place;

  const PlaceTile({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
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
                Text(place.type, style: TextStyle(color: Theme.of(context).hintColor)),
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
                        return DecoratedBox(
                          decoration: BoxDecoration(color: colorFromText(tag), borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                            child: Text(tag),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => PlacePanel(place: place),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
    );
  }
}

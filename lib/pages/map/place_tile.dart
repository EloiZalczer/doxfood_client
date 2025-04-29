import 'package:doxfood/models.dart';
import 'package:doxfood/pages/map/place_panel.dart';
import 'package:doxfood/pages/map/rating.dart';
import 'package:flutter/material.dart';

class PlaceTile extends StatelessWidget {
  final Place place;

  const PlaceTile({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: ContinuousRectangleBorder(
        side: BorderSide(color: Colors.black, width: 1),
      ),
      title: Text(place.name),
      subtitle: PlaceRatingWidget(place: place),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PlacePanel(place: place)),
        );
      },
    );
  }
}

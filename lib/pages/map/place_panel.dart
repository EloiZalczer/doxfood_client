import 'package:doxfood/models.dart';
import 'package:doxfood/pages/map/rating.dart';
import 'package:doxfood/pages/map/review_tile.dart';
import 'package:doxfood/utils/color.dart';
import 'package:flutter/material.dart';

class PlacePanel extends StatelessWidget {
  final Place place;

  const PlacePanel({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Column(
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                place.name,
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ],
          ),
          PlaceRatingWidget(place: place),
          Row(
            children: [
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 10,
                children:
                    place.tags.map((tag) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: colorFromText(tag),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 6,
                          ),
                          child: Text(tag),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: place.reviews.length,
              itemBuilder: (context, index) {
                return ReviewTile(review: place.reviews[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

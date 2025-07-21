import 'package:doxfood/api.dart';
import 'package:doxfood/models/place_types.dart';
import 'package:doxfood/widgets/rating.dart';
import 'package:doxfood/widgets/tag_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuggestionCard extends StatelessWidget {
  final Function(PlaceInfo place)? onClicked;
  final PlaceInfo place;

  const SuggestionCard({super.key, required this.place, this.onClicked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onClicked != null) onClicked!(place);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(place.name, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
              Row(
                spacing: 8.0,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<PlaceTypesModel>(
                    builder: (context, value, child) {
                      return Text(value.getById(place.type).name, style: TextStyle(color: Theme.of(context).hintColor));
                    },
                  ),
                  Text("•", style: TextStyle(color: Theme.of(context).hintColor)),
                  Text(place.price, style: TextStyle(color: Theme.of(context).hintColor)),
                ],
              ),

              PlaceRatingWidget(place: place),
              Row(
                spacing: 8.0,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...place.tags.take(2).map((tag) {
                    return TagChip(tag: tag);
                  }),
                  if (place.tags.length > 2)
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade300),
                      child: Center(child: Text("+${place.tags.length - 2}", textAlign: TextAlign.center)),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:doxfood/models/places.dart';
import 'package:doxfood/models/tags.dart';
import 'package:doxfood/widgets/fields/places_field.dart';
import 'package:doxfood/widgets/fields/price_range_field.dart';
import 'package:doxfood/widgets/fields/tags_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RandomSettingsPage extends StatelessWidget {
  const RandomSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Price", style: TextStyle(fontWeight: FontWeight.bold)),
              PriceRangeField(initialValue: PriceRange(min: 1, max: 4)),
              Text("Include tags", style: TextStyle(fontWeight: FontWeight.bold)),
              Consumer<TagsModel>(
                builder: (context, value, child) {
                  return TagsField(options: value.tags);
                },
              ),
              Text("Exclude tags", style: TextStyle(fontWeight: FontWeight.bold)),
              Consumer<TagsModel>(
                builder: (context, value, child) {
                  return TagsField(options: value.tags);
                },
              ),
              Text("Include places", style: TextStyle(fontWeight: FontWeight.bold)),
              Consumer<PlacesModel>(
                builder: (context, value, child) {
                  return PlacesField(options: value.places);
                },
              ),
              Text("Exclude places", style: TextStyle(fontWeight: FontWeight.bold)),
              Consumer<PlacesModel>(
                builder: (context, value, child) {
                  return PlacesField(options: value.places);
                },
              ),
              ElevatedButton(onPressed: () {}, child: Text("Test")),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:doxfood/models.dart';
import 'package:flutter/material.dart';

class PlaceTile extends StatelessWidget {
  final Place place;

  const PlaceTile({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(place.name));
  }
}

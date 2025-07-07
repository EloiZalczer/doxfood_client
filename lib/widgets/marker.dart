import 'package:doxfood/api.dart';
import 'package:flutter/material.dart';

class PlaceMarker extends StatefulWidget {
  final Place place;
  final Function onTap;

  const PlaceMarker({super.key, required this.place, required this.onTap});

  @override
  State<PlaceMarker> createState() => _PlaceMarkerState();
}

class _PlaceMarkerState extends State<PlaceMarker> {
  final key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.amber, border: Border.all(color: Colors.white)),
        child: Icon(Icons.restaurant, size: 10, color: Colors.white),
      ),
    );
  }
}

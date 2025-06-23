import 'package:doxfood/models.dart';
import 'package:flutter/material.dart';

class PlaceMarker extends StatefulWidget {
  final Widget child;
  final Place place;
  final Function onTap;

  const PlaceMarker({
    super.key,
    required this.child,
    required this.place,
    required this.onTap,
  });

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
      child: widget.child,
    );
  }
}

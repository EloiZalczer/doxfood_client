import 'package:doxfood/api.dart';
import 'package:doxfood/models/place_types.dart';
import 'package:doxfood/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaceMarker extends StatefulWidget {
  final Place place;
  final Function onTap;
  final bool selected;

  const PlaceMarker({super.key, required this.place, required this.onTap, required this.selected});

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
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.selected ? Colors.black : Colors.amber,
          border: Border.all(color: Colors.white),
        ),
        child: Consumer<PlaceTypesModel>(
          builder: (context, value, child) {
            return Icon(iconsMap[value.getById(widget.place.type).icon], size: 10, color: Colors.white);
          },
        ),
      ),
    );
  }
}

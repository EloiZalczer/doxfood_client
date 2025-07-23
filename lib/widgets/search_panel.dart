import 'package:doxfood/api.dart';
import 'package:doxfood/models/location.dart';
import 'package:doxfood/models/place_types.dart';
import 'package:doxfood/models/places.dart';
import 'package:doxfood/utils/distance.dart';
import 'package:doxfood/utils/icons.dart';
import 'package:doxfood/widgets/rating.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPanel extends StatefulWidget {
  const SearchPanel({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {
  List<PlaceInfo> suggestions = [];

  void _updateSuggestions() {
    if (widget.controller.text.isEmpty) {
      setState(() {
        suggestions = [];
      });
    } else {
      setState(() {
        suggestions =
            context
                .read<PlacesModel>()
                .places
                .where((PlaceInfo p) => p.name.toLowerCase().startsWith(widget.controller.text.toLowerCase()))
                .take(10)
                .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateSuggestions);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_updateSuggestions);
  }

  @override
  Widget build(BuildContext context) {
    final location = context.read<LocationModel>().current;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 40,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Center(
                child: TextField(
                  controller: widget.controller,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  style: const TextStyle(height: 0.6),
                  cursorHeight: 20,
                  // showCursor: false,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (suggestions.isNotEmpty)
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final place = suggestions[index];
                  final distance = (location == null) ? null : distanceBetween(location.latLng, place.location);

                  return ListTile(
                    onTap: () {
                      Navigator.pop(context, suggestions[index]);
                    },
                    titleAlignment: ListTileTitleAlignment.top,
                    title: Text(
                      suggestions[index].name,
                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                    ),
                    leading: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: PlaceDistanceIcon(place: place, distance: distance),
                    ),
                    subtitle: PlaceRatingWidget(place: place),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class PlaceDistanceIcon extends StatelessWidget {
  final double? distance;
  final PlaceInfo place;

  const PlaceDistanceIcon({super.key, required this.place, this.distance});

  @override
  Widget build(BuildContext context) {
    final type = context.read<PlaceTypesModel>().getById(place.type);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(iconsMap[type.icon]), if (distance != null) Text("${distance!.toStringAsFixed(2)} km")],
    );
  }
}

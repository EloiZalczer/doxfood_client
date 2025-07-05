import 'dart:math';

import 'package:doxfood/api.dart';
import 'package:doxfood/filtering.dart';
import 'package:doxfood/models/filters.dart';
import 'package:doxfood/models/place_types.dart';
import 'package:doxfood/models/places.dart';
import 'package:doxfood/pages/filters_list.dart';
import 'package:doxfood/widgets/rating.dart';
import 'package:doxfood/widgets/tag_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RandomPage extends StatefulWidget {
  final Function(PlaceInfo place)? onSuggestionClicked;

  const RandomPage({super.key, this.onSuggestionClicked});

  @override
  State<RandomPage> createState() => _RandomPageState();
}

class _RandomPageState extends State<RandomPage> {
  Filter? _currentFilter;
  PlaceInfo? _suggestion;

  final Random _random = Random();

  void suggestRandomPlace() {
    List<PlaceInfo> places = context.read<PlacesModel>().places;

    if (_currentFilter == null) {
      final filters = makeFilters(_currentFilter!);

      places =
          places.where((p) {
            final m = p.place.asMap();
            for (var filter in filters) {
              if (!filter(m)) {
                return false;
              }
            }
            return true;
          }).toList();
    }

    setState(() {
      _suggestion = places[_random.nextInt(places.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_suggestion != null) SuggestionPanel(place: _suggestion!, onClicked: widget.onSuggestionClicked),
            ElevatedButton(onPressed: suggestRandomPlace, child: Text("Get random place")),
            DropdownButton<Filter>(
              items:
                  context
                      .read<FiltersModel>()
                      .filters
                      .map((f) => DropdownMenuItem(value: f, child: Text(f.name)))
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _currentFilter = value;
                });
              },
              value: _currentFilter,
            ),
            TextButton.icon(
              label: const Text("Configure"),
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FiltersListPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SuggestionPanel extends StatelessWidget {
  final Function(PlaceInfo place)? onClicked;
  final PlaceInfo place;

  const SuggestionPanel({super.key, required this.place, this.onClicked});

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

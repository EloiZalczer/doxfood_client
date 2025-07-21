import 'dart:math';

import 'package:doxfood/api.dart';
import 'package:doxfood/filtering.dart';
import 'package:doxfood/models/places.dart';
import 'package:doxfood/widgets/quick_filters_container.dart';
import 'package:doxfood/widgets/saved_filters_container.dart';
import 'package:doxfood/widgets/selectable_container.dart';
import 'package:doxfood/widgets/suggestion_chip.dart';
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

  final SelectionController filteringController = SelectionController(selected: "No filter");

  void suggestRandomPlace() {
    List<PlaceInfo> places = context.read<PlacesModel>().places;

    if (_currentFilter != null) {
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
            Spacer(flex: 2),
            if (_suggestion != null) SuggestionCard(place: _suggestion!, onClicked: widget.onSuggestionClicked),
            ElevatedButton(onPressed: suggestRandomPlace, child: Text("Get random place")),
            Spacer(flex: 1),
            Divider(height: 0),
            SelectableContainer(
              title: "No filter",
              controller: filteringController,
              value: "No filter",
              height: 130,
              child: Container(),
            ),
            // SizedBox(height: 130, child: Center(child: Text("No filter"))),
            Divider(height: 0),
            QuickFiltersContainer(controller: filteringController),
            Divider(height: 0),
            SavedFiltersContainer(controller: filteringController),

            // DropdownButton<Filter>(
            //   items:
            //       context
            //           .read<FiltersModel>()
            //           .filters
            //           .map((f) => DropdownMenuItem(value: f, child: Text(f.name)))
            //           .toList(),
            //   onChanged: (value) {
            //     setState(() {
            //       _currentFilter = value;
            //     });
            //   },
            //   value: _currentFilter,
            // ),
            // TextButton.icon(
            //   label: const Text("Configure"),
            //   icon: const Icon(Icons.settings),
            //   onPressed: () {
            //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FiltersListPage()));
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

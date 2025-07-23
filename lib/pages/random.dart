import 'dart:math';

import 'package:doxfood/api.dart';
import 'package:doxfood/filtering.dart';
import 'package:doxfood/models/filters.dart';
import 'package:doxfood/models/places.dart';
import 'package:doxfood/models/random_config.dart';
import 'package:doxfood/widgets/filter_editor.dart';
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
  PlaceInfo? _suggestion;
  late int _filteredPlacesCount;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    context.read<RandomConfigurationModel>().addListener(_refreshFilteredPlacesCount);
    _refreshFilteredPlacesCount();
  }

  @override
  void dispose() {
    super.dispose();
    context.read<RandomConfigurationModel>().removeListener(_refreshFilteredPlacesCount);
  }

  List<PlaceInfo> _getFilteredPlaces() {
    List<PlaceInfo> places = context.read<PlacesModel>().places;

    RandomConfigurationModel model = context.read<RandomConfigurationModel>();

    if (model.selectedFiltering == "quick_filter" && model.quickFilter != null) {
      final filters = makeFilters(model.quickFilter!);
      return applyFilters(places, filters);
    }

    if (model.selectedFiltering == "saved_filters") {
      final List<bool Function(Map place)> filters = [];
      for (final id in model.selectedFilters) {
        final filter = context.read<FiltersModel>().getById(id);
        filters.addAll(makeFilters(filter.configuration));
      }
      return applyFilters(places, filters);
    }

    return places;
  }

  void _refreshFilteredPlacesCount() {
    setState(() {
      _filteredPlacesCount = _getFilteredPlaces().length;
    });
  }

  void suggestRandomPlace() {
    final places = _getFilteredPlaces();

    if (places.isEmpty) {
      setState(() {
        _suggestion = null;
      });
    } else {
      setState(() {
        _suggestion = places[_random.nextInt(places.length)];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<RandomConfigurationModel?>(
          builder:
              (context, model, child) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 10),
                  if (_suggestion != null) SuggestionCard(place: _suggestion!, onClicked: widget.onSuggestionClicked),
                  ElevatedButton(onPressed: suggestRandomPlace, child: const Text("Get random place")),
                  const Spacer(flex: 1),
                  Text("$_filteredPlacesCount filtered places", style: const TextStyle(color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableContainer(
                      title: "No filter",
                      selected: model?.selectedFiltering == "no_filter",
                      onTap: () => model?.selectedFiltering = "no_filter",
                      height: 70,
                      child: Container(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: QuickFiltersContainer(
                      selected: model?.selectedFiltering == "quick_filter",
                      onTap: () => model?.selectedFiltering = "quick_filter",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SavedFiltersContainer(
                      selected: model?.selectedFiltering == "saved_filters",
                      onTap: () => model?.selectedFiltering = "saved_filters",
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}

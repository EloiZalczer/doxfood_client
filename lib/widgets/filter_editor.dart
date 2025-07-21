import 'package:doxfood/api.dart';
import 'package:doxfood/controllers/multiple_selection_controller.dart';
import 'package:doxfood/models/place_types.dart';
import 'package:doxfood/models/places.dart';
import 'package:doxfood/models/tags.dart';
import 'package:doxfood/widgets/fields/place_type_field.dart';
import 'package:doxfood/widgets/fields/places_field.dart';
import 'package:doxfood/widgets/fields/price_range_field.dart';
import 'package:doxfood/widgets/fields/tags_field.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:provider/provider.dart';

class FilterConfiguration {
  final bool priceRangeEnabled;
  final bool includeTagsEnabled;
  final bool excludeTagsEnabled;
  final bool includePlacesEnabled;
  final bool excludePlacesEnabled;
  final ID placeType;
  final String lowerPriceBound;
  final String upperPriceBound;
  final List<ID> includedTags;
  final List<ID> excludedTags;
  final List<ID> includedPlaces;
  final List<ID> excludedPlaces;

  FilterConfiguration({
    required this.priceRangeEnabled,
    required this.includeTagsEnabled,
    required this.excludeTagsEnabled,
    required this.includePlacesEnabled,
    required this.excludePlacesEnabled,
    required this.placeType,
    required this.lowerPriceBound,
    required this.upperPriceBound,
    required this.includedTags,
    required this.excludedTags,
    required this.includedPlaces,
    required this.excludedPlaces,
  });
}

class FilterEditor extends StatefulWidget {
  final FilterConfiguration? filter;

  const FilterEditor({super.key, this.filter});

  @override
  State<FilterEditor> createState() => FilterEditorState();
}

class FilterEditorState extends State<FilterEditor> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late bool _priceRangeEnabled = (widget.filter == null) ? false : widget.filter!.priceRangeEnabled;
  late bool _includeTagsEnabled = (widget.filter == null) ? false : widget.filter!.includeTagsEnabled;
  late bool _excludeTagsEnabled = (widget.filter == null) ? false : widget.filter!.excludeTagsEnabled;
  late bool _includePlacesEnabled = (widget.filter == null) ? false : widget.filter!.includePlacesEnabled;
  late bool _excludePlacesEnabled = (widget.filter == null) ? false : widget.filter!.excludePlacesEnabled;

  late PlaceTypeController _placeTypeController;
  late MultipleSelectionController _includedTagsController;
  late MultipleSelectionController _excludedTagsController;
  late PriceRangeController _priceRangeController;

  final MultiSelectController<PlaceInfo> _includedPlacesController = MultiSelectController<PlaceInfo>();
  final MultiSelectController<PlaceInfo> _excludedPlacesController = MultiSelectController<PlaceInfo>();

  bool validate() {
    return _formKey.currentState!.validate();
  }

  FilterConfiguration data() {
    return FilterConfiguration(
      priceRangeEnabled: _priceRangeEnabled,
      includeTagsEnabled: _includeTagsEnabled,
      excludeTagsEnabled: _excludeTagsEnabled,
      includePlacesEnabled: _includePlacesEnabled,
      excludePlacesEnabled: _excludePlacesEnabled,
      placeType: _placeTypeController.type!.id,
      lowerPriceBound: priceToLabel(_priceRangeController.min),
      upperPriceBound: priceToLabel(_priceRangeController.max),
      includedTags: _includedTagsController.selected.toList(),
      excludedTags: _excludedTagsController.selected.toList(),
      includedPlaces: _includedPlacesController.selectedItems.map((item) => item.value.id).toList(),
      excludedPlaces: _excludedPlacesController.selectedItems.map((item) => item.value.id).toList(),
    );
  }

  @override
  void initState() {
    super.initState();

    PlaceType? placeType;
    if (widget.filter != null) {
      placeType = context.read<PlaceTypesModel>().getById(widget.filter!.placeType);
    } else {
      placeType = null;
    }
    _placeTypeController = PlaceTypeController(type: placeType);

    final List<String> includedTags = (widget.filter == null) ? [] : widget.filter!.includedTags;
    _includedTagsController = MultipleSelectionController(selected: includedTags);

    final List<String> excludedTags = (widget.filter == null) ? [] : widget.filter!.excludedTags;
    _excludedTagsController = MultipleSelectionController(selected: excludedTags);

    final String lowerPriceBound = (widget.filter == null) ? "€" : widget.filter!.lowerPriceBound;
    final String upperPriceBound = (widget.filter == null) ? "€€€€" : widget.filter!.upperPriceBound;
    _priceRangeController = PriceRangeController(
      min: labelToPrice(lowerPriceBound),
      max: labelToPrice(upperPriceBound),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Consumer<PlaceTypesModel>(
                builder: (context, model, child) {
                  return PlaceTypeField(
                    options: model.placeTypes,
                    label: "Place type",
                    controller: _placeTypeController,
                  );
                },
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SwitchListTile(
                  value: _priceRangeEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _priceRangeEnabled = value;
                    });
                  },
                  title: const Text("Price"),
                ),
                PriceRangeField(controller: _priceRangeController, enabled: _priceRangeEnabled),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SwitchListTile(
                  value: _includeTagsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _includeTagsEnabled = value;
                    });
                  },
                  title: const Text("Include tags"),
                ),
                Consumer<TagsModel>(
                  builder: (context, value, child) {
                    return TagsField(
                      options: value.tags,
                      enabled: _includeTagsEnabled,
                      controller: _includedTagsController,
                    );
                  },
                ),
              ],
            ),
          ),

          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SwitchListTile(
                  value: _excludeTagsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _excludeTagsEnabled = value;
                    });
                  },
                  title: const Text("Exclude tags"),
                ),
                Consumer<TagsModel>(
                  builder: (context, value, child) {
                    return TagsField(
                      options: value.tags,
                      enabled: _excludeTagsEnabled,
                      controller: _excludedTagsController,
                    );
                  },
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SwitchListTile(
                  value: _includePlacesEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _includePlacesEnabled = value;
                    });
                  },
                  title: const Text("Include places"),
                ),
                Consumer<PlacesModel>(
                  builder: (context, value, child) {
                    return PlacesField(
                      options: value.places,
                      enabled: _includePlacesEnabled,
                      initialValue: (widget.filter == null) ? [] : widget.filter!.includedPlaces,
                      controller: _includedPlacesController,
                    );
                  },
                ),
              ],
            ),
          ),

          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SwitchListTile(
                  value: _excludePlacesEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _excludePlacesEnabled = value;
                    });
                  },
                  title: const Text("Exclude places"),
                ),
                Consumer<PlacesModel>(
                  builder: (context, value, child) {
                    return PlacesField(
                      options: value.places,
                      enabled: _excludePlacesEnabled,
                      initialValue: (widget.filter == null) ? [] : widget.filter!.excludedPlaces,
                      controller: _excludedPlacesController,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

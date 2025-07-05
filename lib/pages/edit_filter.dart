import 'package:doxfood/api.dart';
import 'package:doxfood/models/filters.dart';
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

class EditFilterPage extends StatefulWidget {
  final Filter? filter;

  const EditFilterPage({super.key, this.filter});

  @override
  State<EditFilterPage> createState() => _EditFilterPageState();
}

class _EditFilterPageState extends State<EditFilterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late bool _priceRangeEnabled = (widget.filter == null) ? false : widget.filter!.priceRangeEnabled;
  late bool _includeTagsEnabled = (widget.filter == null) ? false : widget.filter!.includeTagsEnabled;
  late bool _excludeTagsEnabled = (widget.filter == null) ? false : widget.filter!.excludeTagsEnabled;
  late bool _includePlacesEnabled = (widget.filter == null) ? false : widget.filter!.includePlacesEnabled;
  late bool _excludePlacesEnabled = (widget.filter == null) ? false : widget.filter!.excludePlacesEnabled;

  late PlaceTypeController _placeTypeController;
  late TagsController _includedTagsController;
  late TagsController _excludedTagsController;
  late PriceRangeController _priceRangeController;
  late TextEditingController _filterNameController;

  final MultiSelectController<PlaceInfo> _includedPlacesController = MultiSelectController<PlaceInfo>();
  final MultiSelectController<PlaceInfo> _excludedPlacesController = MultiSelectController<PlaceInfo>();

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await context.read<FiltersModel>().save(
      (widget.filter != null) ? widget.filter!.id : null,
      _filterNameController.text,
      _priceRangeEnabled,
      _includeTagsEnabled,
      _excludeTagsEnabled,
      _includePlacesEnabled,
      _excludePlacesEnabled,
      _placeTypeController.type!.id,
      priceToLabel(_priceRangeController.min),
      priceToLabel(_priceRangeController.max),
      _includedTagsController.selected.toList(),
      _excludedTagsController.selected.toList(),
      _includedPlacesController.selectedItems.map((item) => item.value.id).toList(),
      _excludedPlacesController.selectedItems.map((item) => item.value.id).toList(),
    );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    final String? filterName = (widget.filter == null) ? null : widget.filter!.name;
    _filterNameController = TextEditingController(text: filterName);

    PlaceType? placeType;
    if (widget.filter != null) {
      placeType = context.read<PlaceTypesModel>().getById(widget.filter!.placeType);
    } else {
      placeType = null;
    }
    _placeTypeController = PlaceTypeController(type: placeType);

    final List<String> includedTags = (widget.filter == null) ? [] : widget.filter!.includedTags;
    _includedTagsController = TagsController(selected: includedTags);

    final List<String> excludedTags = (widget.filter == null) ? [] : widget.filter!.excludedTags;
    _excludedTagsController = TagsController(selected: excludedTags);

    final String lowerPriceBound = (widget.filter == null) ? "€" : widget.filter!.lowerPriceBound;
    final String upperPriceBound = (widget.filter == null) ? "€€€€" : widget.filter!.upperPriceBound;
    _priceRangeController = PriceRangeController(
      min: labelToPrice(lowerPriceBound),
      max: labelToPrice(upperPriceBound),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(title: FilterNameField(controller: _filterNameController)),
        body: Center(
          child: SingleChildScrollView(
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
          ),
        ),
        bottomNavigationBar: ElevatedButton(onPressed: _submit, child: Text("Save")),
      ),
    );
  }
}

class FilterNameField extends StatefulWidget {
  final TextEditingController? controller;

  const FilterNameField({super.key, this.controller});

  @override
  State<FilterNameField> createState() => _FilterNameFieldState();
}

class _FilterNameFieldState extends State<FilterNameField> {
  late TextEditingController _controller;

  late FocusNode _focusNode;

  bool _editing = false;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _controller = TextEditingController();
    } else {
      _controller = widget.controller!;
    }

    _focusNode = FocusNode();

    if (_controller.text.isEmpty) _startEditing();
  }

  void _startEditing() {
    setState(() {
      _editing = true;
    });

    _focusNode.requestFocus();
  }

  void _stopEditing() {
    setState(() {
      _editing = false;
    });

    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      readOnly: !_editing,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        border: InputBorder.none,
        suffixIcon:
            _editing
                ? IconButton(onPressed: _stopEditing, icon: Icon(Icons.check))
                : IconButton(onPressed: _startEditing, icon: Icon(Icons.edit)),
      ),
    );
  }
}

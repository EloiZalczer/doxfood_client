import 'package:doxfood/api.dart';
import 'package:doxfood/models/place_types.dart';
import 'package:doxfood/models/places.dart';
import 'package:doxfood/models/tags.dart';
import 'package:doxfood/widgets/fields/place_type_field.dart';
import 'package:doxfood/widgets/fields/places_field.dart';
import 'package:doxfood/widgets/fields/price_range_field.dart';
import 'package:doxfood/widgets/fields/tags_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditFilterPage extends StatefulWidget {
  final Filter? filter;

  const EditFilterPage({super.key, this.filter});

  @override
  State<EditFilterPage> createState() => _EditFilterPageState();
}

class _EditFilterPageState extends State<EditFilterPage> {
  late bool _priceRangeEnabled = (widget.filter == null) ? false : widget.filter!.priceRangeEnabled;
  late bool _includeTagsEnabled = (widget.filter == null) ? false : widget.filter!.includeTagsEnabled;
  late bool _excludeTagsEnabled = (widget.filter == null) ? false : widget.filter!.excludeTagsEnabled;
  late bool _includePlacesEnabled = (widget.filter == null) ? false : widget.filter!.includePlacesEnabled;
  late bool _excludePlacesEnabled = (widget.filter == null) ? false : widget.filter!.excludePlacesEnabled;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(title: FilterNameField()),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<PlaceTypesModel>(
                    builder: (context, model, child) {
                      return PlaceTypeField(options: model.placeTypes, label: "Place type");
                    },
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
                      PriceRangeField(initialValue: PriceRange(min: 1, max: 4), enabled: _priceRangeEnabled),
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
                          return TagsField(options: value.tags, enabled: _includeTagsEnabled);
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
                          return TagsField(options: value.tags, enabled: _excludeTagsEnabled);
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
                          return PlacesField(options: value.places, enabled: _includePlacesEnabled);
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
                          return PlacesField(options: value.places, enabled: _excludePlacesEnabled);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: ElevatedButton(onPressed: () {}, child: Text("Save")),
      ),
    );
  }
}

class FilterNameField extends StatefulWidget {
  const FilterNameField({super.key});

  @override
  State<FilterNameField> createState() => _FilterNameFieldState();
}

class _FilterNameFieldState extends State<FilterNameField> {
  final _controller = TextEditingController(text: "Filter");

  late FocusNode _focusNode;
  bool _editing = false;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
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

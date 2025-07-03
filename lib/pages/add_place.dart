import 'package:doxfood/api.dart';
import 'package:doxfood/models/place_types.dart';
import 'package:doxfood/models/places.dart';
import 'package:doxfood/models/tags.dart';
import 'package:doxfood/widgets/fields/gmaps_link_field.dart';
import 'package:doxfood/widgets/fields/place_type_field.dart';
import 'package:doxfood/widgets/fields/price_field.dart';
import 'package:doxfood/widgets/fields/tags_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:provider/provider.dart';

const _pricesMap = ["€", "€€", "€€€", "€€€€"];

class AddPlacePage extends StatefulWidget {
  final LatLng point;

  const AddPlacePage({super.key, required this.point});

  @override
  State<StatefulWidget> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = PriceController();
  final _tagsController = MultiSelectController();
  final _placeTypeController = PlaceTypeController();
  final _descriptionController = TextEditingController();

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await context.read<PlacesModel>().createPlace(
      location: widget.point,
      name: _nameController.text,
      type: _placeTypeController.type!.id,
      price: _pricesMap[_priceController.price!],
      tags: _tagsController.items.map((e) => e.value as Tag).toList(),
      description: _descriptionController.text,
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    _focusNode.requestFocus();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Create new place")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 12.0,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 100,
                  child: IgnorePointer(
                    child: FlutterMap(
                      options: MapOptions(initialCenter: widget.point, initialZoom: 18),
                      children: [
                        TileLayer(
                          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                          userAgentPackageName: "com.doxfood.app",
                        ),
                        MarkerLayer(markers: [Marker(point: widget.point, child: FlutterLogo())]),
                      ],
                    ),
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(hintText: "Description (optional)"),
                ),
                Consumer<PlaceTypesModel>(
                  builder: (context, model, child) {
                    return PlaceTypeField(options: model.placeTypes, controller: _placeTypeController);
                  },
                ),
                Consumer<TagsModel>(
                  builder: (context, model, child) {
                    return OtherTagsField(options: model.tags);
                  },
                ),
                Text("Price"),
                PriceField(controller: _priceController),
                GoogleMapsLinkField(),
                Spacer(),
                ElevatedButton(onPressed: _submit, child: Text("Create")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

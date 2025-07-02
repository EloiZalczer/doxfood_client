import 'package:doxfood/api.dart';
import 'package:doxfood/models/place_types.dart';
import 'package:doxfood/models/places.dart';
import 'package:doxfood/models/tags.dart';
import 'package:doxfood/widgets/fields/gmaps_link_field.dart';
import 'package:doxfood/widgets/fields/price_field.dart';
import 'package:doxfood/widgets/fields/tags_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
  PlaceType? _type;

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

    await context.read<PlacesModel>().create(
      Place(
        latitude: widget.point.latitude,
        longitude: widget.point.longitude,
        name: _nameController.text,
        type: _type!.id,
        price: _pricesMap[_priceController.price!],
      ),
    );

    Navigator.pop(context);
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
                Consumer<PlaceTypesModel>(
                  builder: (context, model, child) {
                    return DropdownButtonFormField(
                      items: model.placeTypes.map((pt) => DropdownMenuItem(value: pt, child: Text(pt.name))).toList(),
                      onChanged: (s) {
                        setState(() {
                          _type = s;
                        });
                      },
                      decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "Type"),
                    );
                  },
                ),
                Consumer<TagsModel>(
                  builder: (context, model, child) {
                    return TagsField(options: model.tags);
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

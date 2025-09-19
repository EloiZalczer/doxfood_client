import 'package:doxfood/controllers/multiple_selection_controller.dart';
import 'package:doxfood/dialogs/create_tag.dart';
import 'package:doxfood/models/place_types.dart';
import 'package:doxfood/models/places.dart';
import 'package:doxfood/models/tags.dart';
import 'package:doxfood/utils/validators.dart';
import 'package:doxfood/widgets/fields/gmaps_link_field.dart';
import 'package:doxfood/widgets/fields/place_type_field.dart';
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
  final _tagsController = MultipleSelectionController();
  late PlaceTypeController _placeTypeController;
  final _descriptionController = TextEditingController();

  late FocusNode _focusNode;

  void _onCreateTag() async {
    final model = context.read<TagsModel>();

    final result = await CreateTagDialog.show(context, _placeTypeController.type!); // FIXME type is nullable

    if (result != null) {
      await model.create(result.placeType, result.name);
    }
  }

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    final defaultPlaceType = context.read<PlaceTypesModel>().placeTypes.first;

    _placeTypeController = PlaceTypeController(type: defaultPlaceType);

    _focusNode.requestFocus();
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
      tags: _tagsController.selected.toList(),
      description: _descriptionController.text,
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(title: const Text("Create new place")),
        body: Form(
          key: _formKey,
          child: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                spacing: 12.0,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        MapPreview(point: widget.point),
                        TextFormField(
                          controller: _nameController,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "Name"),
                          validator: validateRequired,
                        ),
                        Consumer<PlaceTypesModel>(
                          builder: (context, model, child) {
                            return PlaceTypeField(options: model.placeTypes, controller: _placeTypeController);
                          },
                        ),
                      ],
                    ),
                  ),

                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChangeNotifierProvider<PlaceTypeController>.value(
                      value: _placeTypeController,
                      child: Consumer2<TagsModel, PlaceTypeController>(
                        builder: (context, tags, placeType, child) {
                          return TagsField(
                            options: (placeType.type != null) ? tags.getByPlaceType(placeType.type!.id) : [],
                            onCreateTag: _onCreateTag,
                            controller: _tagsController,
                          );
                        },
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [const Text("Price"), PriceField(controller: _priceController)]),
                  ),

                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _descriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(hintText: "Description (optional)"),
                        ),
                        GoogleMapsLinkField(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          // Hack to keep the bottomNavigationBar displayed when the
          // virtual keyboard shows up
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Material(
            elevation: 15,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(onPressed: _submit, child: const Text("Create")),
            ),
          ),
        ),
      ),
    );
  }
}

class MapPreview extends StatelessWidget {
  final LatLng point;

  const MapPreview({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: IgnorePointer(
        child: FlutterMap(
          options: MapOptions(initialCenter: point, initialZoom: 18),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: "com.doxfood.app",
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: point,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber,
                      border: Border.all(color: Colors.white),
                    ),
                    child: const Icon(Icons.add, size: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:doxfood/api.dart';
import 'package:flutter/material.dart';

class PlaceTypeField extends StatefulWidget {
  final PlaceTypeController? controller;
  final List<PlaceType> options;

  const PlaceTypeField({super.key, this.controller, required this.options});

  @override
  State<PlaceTypeField> createState() => _PlaceTypeFieldState();
}

class _PlaceTypeFieldState extends State<PlaceTypeField> {
  late PlaceTypeController controller = widget.controller ?? PlaceTypeController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: widget.options.map((pt) => DropdownMenuItem(value: pt, child: Text(pt.name))).toList(),
      onChanged: (s) => controller.type = s,
      value: controller.type,
      decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "Type"),
    );
  }
}

class PlaceTypeController extends ChangeNotifier {
  PlaceType? _type;

  PlaceTypeController({PlaceType? type}) : _type = type;

  set type(PlaceType? value) {
    _type = value;
    notifyListeners();
  }

  PlaceType? get type => _type;
}

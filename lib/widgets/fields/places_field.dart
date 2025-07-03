import 'package:doxfood/api.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class PlacesField extends FormField<List<PlaceInfo>> {
  PlacesField({
    super.key,
    super.onSaved,
    super.validator,
    List<PlaceInfo> super.initialValue = const [],
    required List<PlaceInfo> options,
    MultiSelectController<PlaceInfo>? controller,
    bool autovalidate = false,
  }) : super(
         builder: (FormFieldState<List<PlaceInfo>> state) {
           return MultiDropdown(
             controller: controller,
             items: options.map((opt) => DropdownItem(label: opt.name, value: opt)).toList(),
             fieldDecoration: FieldDecoration(labelText: "Places", border: UnderlineInputBorder()),
           );
         },
       );
}

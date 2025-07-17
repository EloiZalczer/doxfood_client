import 'package:doxfood/api.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class PlacesField extends FormField<List<PlaceInfo>> {
  PlacesField({
    super.key,
    super.onSaved,
    super.validator,
    List<ID> initialValue = const [],
    required List<PlaceInfo> options,
    MultiSelectController<PlaceInfo>? controller,
    bool autovalidate = false,
    bool enabled = true,
  }) : super(
         builder: (FormFieldState<List<PlaceInfo>> state) {
           return MultiDropdown(
             enabled: enabled,
             searchEnabled: true,
             controller: controller,
             items:
                 options
                     .map((opt) => DropdownItem(label: opt.name, value: opt, selected: initialValue.contains(opt.id)))
                     .toList(),
             fieldDecoration: FieldDecoration(labelText: "Places", border: UnderlineInputBorder()),
           );
         },
       );
}

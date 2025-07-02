import 'package:doxfood/api.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class TagsField extends FormField<List<String>> {
  TagsField({
    super.key,
    super.onSaved,
    super.validator,
    List<String> super.initialValue = const [],
    required List<Tag> options,
    bool autovalidate = false,
  }) : super(
         builder: (FormFieldState<List<String>> state) {
           return MultiDropdown(
             items: options.map((opt) => DropdownItem(label: opt.name, value: opt.id)).toList(),
             fieldDecoration: FieldDecoration(labelText: "Tags", border: UnderlineInputBorder()),
           );
         },
       );
}

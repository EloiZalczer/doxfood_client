import 'package:flutter/material.dart';

class GoogleMapsLinkField extends FormField<String> {
  GoogleMapsLinkField({
    super.key,
    super.onSaved,
    super.validator,
    String super.initialValue = "",
    bool autovalidate = false,
  }) : super(
         builder: (FormFieldState<String> state) {
           return TextFormField(
             validator: (value) {
               if (value == null || value.isEmpty) return null;

               final RegExp exp = RegExp(r'https://maps.app.goo.gl/[a-zA-Z0-9]+');
               final match = exp.firstMatch(value);

               if (match == null) {
                 return "Not a valid Google Maps link";
               }
               return null;
             },
             decoration: const InputDecoration(
               border: UnderlineInputBorder(),
               labelText: "Google Maps link (optional)",
             ),
           );
         },
       );
}

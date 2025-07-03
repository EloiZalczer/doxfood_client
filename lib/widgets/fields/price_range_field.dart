import 'package:flutter/material.dart';

class PriceRange {
  final int min;
  final int max;

  PriceRange({required this.min, required this.max});
}

String priceToLabel(int price) {
  return "€" * price;
}

class PriceRangeField extends FormField<PriceRange> {
  PriceRangeField({
    super.key,
    super.onSaved,
    super.validator,
    required PriceRange super.initialValue,
    bool autovalidate = false,
  }) : super(
         builder: (FormFieldState<PriceRange> state) {
           return RangeSlider(
             min: 1,
             max: 4,
             values: RangeValues(state.value!.min.toDouble(), state.value!.max.toDouble()),
             labels: RangeLabels(priceToLabel(state.value!.min), priceToLabel(state.value!.max)),
             divisions: 3,
             onChanged: (RangeValues values) {
               if (values.start == values.end) return;

               state.didChange(PriceRange(min: values.start.toInt(), max: values.end.toInt()));
             },
           );
         },
       );
}

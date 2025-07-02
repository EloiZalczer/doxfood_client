import 'package:doxfood/models/tags.dart';
import 'package:doxfood/widgets/fields/tags_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RandomSettingsPage extends StatelessWidget {
  const RandomSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ListTile(title: Text("Price"), subtitle: PriceRangeField(initialValue: PriceRange(min: 1, max: 4))),
              // Container(
              //   height: 200,
              //   child: ListTile(
              //     title: Text("Include tags"),
              //     subtitle: Consumer<TagsModel>(
              //       builder: (context, value, child) {
              //         return TagsField(options: value.tags);
              //       },
              //     ),
              //   ),
              // ),
              Text("Price"),
              PriceRangeField(initialValue: PriceRange(min: 1, max: 4)),
              Text("Include tags", style: TextStyle(fontWeight: FontWeight.bold)),
              Consumer<TagsModel>(
                builder: (context, value, child) {
                  return TagsField(options: value.tags);
                },
              ),

              // Text("Price"),
              // PriceRangeField(initialValue: PriceRange(min: 1, max: 4)),
              // Consumer<TagsModel>(
              //   builder: (context, value, child) {
              //     return TagsField(options: value.tags);
              //   },
              // ),
              ElevatedButton(onPressed: () {}, child: Text("Test")),
            ],
          ),
        ),
      ),
    );
  }
}

class PriceRange {
  final int min;
  final int max;

  PriceRange({required this.min, required this.max});
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

String priceToLabel(int price) {
  return "€" * price;
}

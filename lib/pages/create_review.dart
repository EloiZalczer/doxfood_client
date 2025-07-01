import 'package:doxfood/api.dart';
import 'package:doxfood/widgets/rating_field.dart';
import 'package:flutter/material.dart';

class CreateReviewPage extends StatefulWidget {
  final Place place;
  final int? rating;

  const CreateReviewPage({super.key, required this.place, this.rating});

  @override
  State<CreateReviewPage> createState() => _CreateReviewPageState();
}

class _CreateReviewPageState extends State<CreateReviewPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.place.name)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              children: [
                RatingField(controller: RatingController(rating: widget.rating)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(hintText: "Leave a review"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      } else if (!value.contains(RegExp('[a-zA-Z]'))) {
                        return "This field must contain text";
                      }
                      return null;
                    },
                  ),
                ),
                Spacer(),
                ElevatedButton(onPressed: _submit, child: Text("Publish")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

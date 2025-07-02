import 'package:doxfood/api.dart';
import 'package:doxfood/models/places.dart';
import 'package:doxfood/widgets/fields/rating_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddReviewPage extends StatefulWidget {
  final Place place;
  final int? rating;

  const AddReviewPage({super.key, required this.place, this.rating});

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late RatingController _ratingController = RatingController(rating: widget.rating);
  final TextEditingController _textController = TextEditingController();

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final model = context.read<PlacesModel>();

    await model.createReview(
      widget.place.id,
      Review(
        rating: _ratingController.rating!,
        text: _textController.text,
        user: User(id: model.getCurrentUserId(), username: ""),
      ),
    );

    if (mounted) Navigator.pop(context);
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
                RatingField(controller: _ratingController),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _textController,
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

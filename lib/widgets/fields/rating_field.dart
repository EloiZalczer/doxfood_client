import 'package:doxfood/theme.dart';
import 'package:flutter/material.dart';

class RatingField extends StatefulWidget {
  final Function(int rating)? onRatingSelected;
  final int starCount;
  final RatingController? controller;
  const RatingField({
    super.key,
    this.onRatingSelected,
    this.controller,
    this.starCount = 5, // Default to 5 stars
  });

  @override
  State<RatingField> createState() => _RatingFieldState();
}

class _RatingFieldState extends State<RatingField> {
  late RatingController controller;

  @override
  void initState() {
    super.initState();

    controller = widget.controller ?? RatingController();

    controller.addListener(() {
      setState(() {});
    });
  }

  void onStarTapped(BuildContext context, int rating) {
    if (widget.onRatingSelected != null) {
      widget.onRatingSelected!(rating);
    } else {
      controller.rating = rating;
    }
  }

  @override
  Widget build(final BuildContext context) {
    // Creating a row of stars based on the starCount
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        widget.starCount, // Generate a row with 'starCount' stars
        (final index) {
          if (controller.rating == null || controller.rating! <= index) {
            return GestureDetector(
              child: const Icon(Icons.star_border, size: 50, color: StarColors.secondaryContainerGray),
              onTap: () => onStarTapped(context, index + 1),
            );
          } else {
            return GestureDetector(
              child: const Icon(Icons.star, size: 50, color: StarColors.ratingPrimaryColor),
              onTap: () => onStarTapped(context, index + 1),
            );
          }
        },
      ),
    );
  }
}

class RatingController extends ChangeNotifier {
  int? _rating;

  RatingController({int? rating}) : _rating = rating;

  set rating(int? value) {
    _rating = value;
    notifyListeners();
  }

  int? get rating => _rating;
}

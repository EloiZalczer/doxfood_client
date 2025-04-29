import 'package:doxfood/models.dart';
import 'package:flutter/material.dart';

class PlaceRatingWidget extends StatelessWidget {
  const PlaceRatingWidget({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 5,
      children: [
        Text(
          place.averageRating.toStringAsFixed(1),
          style: TextStyle(color: Theme.of(context).hintColor),
        ),
        StarRatingWidget(rating: place.averageRating),
        Text(
          "(${place.reviews.length})",
          style: TextStyle(color: Theme.of(context).hintColor),
        ),
      ],
    );
  }
}

// You can replace these colors with your theme or custom color values.
class AppColors {
  static const Color secondaryContainerGray = Color(0xFFB0BEC5);
  static const Color ratingPrimaryColor = Color(
    0xFFFFD700,
  ); // Gold color for rating stars
}

class StarRatingWidget extends StatelessWidget {
  final int starCount;
  final double rating;
  final Color? color;
  const StarRatingWidget({
    super.key,
    this.starCount = 5, // Default to 5 stars
    this.rating = 0.0, // Default rating is 0
    this.color, // Optional: custom color for stars
  });
  // Method to build each individual star based on the rating and index
  Widget buildStar(final BuildContext context, final int index) {
    Icon icon;
    // If the index is greater than or equal to the rating, we show an empty star
    if (index >= rating) {
      icon = const Icon(
        Icons.star_border, // Empty star
        size: 16,
        color: AppColors.secondaryContainerGray, // Light gray for empty stars
      );
    }
    // If the index is between the rating minus 1 and the rating, we show a half star
    else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half, // Half star
        size: 16,
        color:
            color ??
            AppColors
                .ratingPrimaryColor, // Default to gold color or custom color
      );
    }
    // Otherwise, we show a full star
    else {
      icon = Icon(
        Icons.star, // Full star
        size: 16,
        color:
            color ??
            AppColors
                .ratingPrimaryColor, // Default to gold color or custom color
      );
    }
    return icon;
  }

  @override
  Widget build(final BuildContext context) {
    // Creating a row of stars based on the starCount
    return Row(
      children: List.generate(
        starCount, // Generate a row with 'starCount' stars
        (final index) => buildStar(context, index),
      ),
    );
  }
}

import 'package:doxfood/api.dart';
import 'package:doxfood/theme.dart';
import 'package:flutter/material.dart';

class PlaceRatingWidget extends StatelessWidget {
  const PlaceRatingWidget({super.key, required this.place, this.dense = false});

  final bool dense;
  final PlaceInfo place;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Text(place.averageRating.toStringAsFixed(1), style: TextStyle(color: Theme.of(context).hintColor)),
        dense
            ? Icon(Icons.star, size: 16, color: StarColors.ratingPrimaryColor)
            : StarRatingWidget(rating: place.averageRating),
        Text("(${place.ratings.length})", style: TextStyle(color: Theme.of(context).hintColor)),
      ],
    );
  }
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
        color: StarColors.secondaryContainerGray, // Light gray for empty stars
      );
    }
    // If the index is between the rating minus 1 and the rating, we show a half star
    else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half, // Half star
        size: 16,
        color: color ?? StarColors.ratingPrimaryColor, // Default to gold color or custom color
      );
    }
    // Otherwise, we show a full star
    else {
      icon = Icon(
        Icons.star, // Full star
        size: 16,
        color: color ?? StarColors.ratingPrimaryColor, // Default to gold color or custom color
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

class ReviewsRatingWidget extends StatelessWidget {
  final List<Review> reviews;

  const ReviewsRatingWidget({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    final double averageRating =
        reviews.isNotEmpty ? reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length : 0;

    final Map<int, int> counts = {};

    for (final review in reviews) {
      if (counts.containsKey(review.rating)) {
        counts.update(review.rating, (value) => value + 1);
      } else {
        counts[review.rating] = 1;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(averageRating.toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24)),
            StarRatingWidget(rating: averageRating),
            Text("(${reviews.length})"),
          ],
        ),
        Column(
          spacing: 10,
          children: [
            RatingRow(relativeHeight: counts.containsKey(5) ? counts[5]! / reviews.length : 0, maxWidth: 200),
            RatingRow(relativeHeight: counts.containsKey(4) ? counts[4]! / reviews.length : 0, maxWidth: 200),
            RatingRow(relativeHeight: counts.containsKey(3) ? counts[3]! / reviews.length : 0, maxWidth: 200),
            RatingRow(relativeHeight: counts.containsKey(2) ? counts[2]! / reviews.length : 0, maxWidth: 200),
            RatingRow(relativeHeight: counts.containsKey(1) ? counts[1]! / reviews.length : 0, maxWidth: 200),
          ],
        ),
      ],
    );
  }
}

class RatingRow extends StatelessWidget {
  final double relativeHeight;
  final double maxWidth;
  final double height = 5;

  const RatingRow({super.key, required this.relativeHeight, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: height,
              width: maxWidth,
              decoration: BoxDecoration(
                color: StarColors.secondaryContainerGray,
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
            Container(
              height: height,
              width: maxWidth * relativeHeight,
              decoration: BoxDecoration(
                color: StarColors.ratingPrimaryColor,
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

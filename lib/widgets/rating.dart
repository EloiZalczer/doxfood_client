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
            ? const Icon(Icons.star, size: 16, color: StarColors.ratingPrimaryColor)
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
  final double starSize;
  const StarRatingWidget({super.key, this.starCount = 5, this.rating = 0.0, this.starSize = 16, this.color});

  Widget _buildStar(final BuildContext context, final int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(Icons.star_border, size: starSize, color: StarColors.secondaryContainerGray);
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(Icons.star_half, size: starSize, color: color ?? StarColors.ratingPrimaryColor);
    } else {
      icon = Icon(Icons.star, size: starSize, color: color ?? StarColors.ratingPrimaryColor);
    }
    return icon;
  }

  @override
  Widget build(final BuildContext context) {
    return Row(children: List.generate(starCount, (final index) => _buildStar(context, index)));
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
            Text(averageRating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 24)),
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
              decoration: const BoxDecoration(
                color: StarColors.secondaryContainerGray,
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
            Container(
              height: height,
              width: maxWidth * relativeHeight,
              decoration: const BoxDecoration(
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

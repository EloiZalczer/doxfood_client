import 'package:doxfood/models.dart';
import 'package:doxfood/pages/map/rating.dart';
import 'package:flutter/material.dart';

class ReviewTile extends StatelessWidget {
  final Review review;

  const ReviewTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: ContinuousRectangleBorder(
        side: BorderSide(color: Colors.black, width: 1),
      ),
      title: Text(review.user.username),
      subtitle: Column(
        children: [
          StarRatingWidget(rating: review.rating.toDouble()),
          Text(review.text),
        ],
      ),
    );
  }
}

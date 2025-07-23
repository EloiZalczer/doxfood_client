import 'package:doxfood/api.dart';
import 'package:doxfood/widgets/rating.dart';
import 'package:doxfood/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class ReviewTile extends StatelessWidget {
  final Review review;

  const ReviewTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const ContinuousRectangleBorder(side: BorderSide(color: Colors.black, width: 1)),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(spacing: 6, children: [UserAvatar(user: review.user), Text(review.user.username)]),
      ),
      subtitle: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [StarRatingWidget(rating: review.rating.toDouble()), Text(review.text)],
      ),
    );
  }
}

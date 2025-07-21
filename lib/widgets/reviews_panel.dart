import 'package:doxfood/api.dart';
import 'package:doxfood/models/places.dart';
import 'package:doxfood/widgets/rating.dart';
import 'package:doxfood/widgets/fields/rating_field.dart';
import 'package:doxfood/widgets/review_tile.dart';
import 'package:doxfood/widgets/sort_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReviewsPanel extends StatefulWidget {
  final PlaceInfo place;
  final Function(int rating)? onAddReview;

  const ReviewsPanel({super.key, required this.place, this.onAddReview});

  @override
  State<ReviewsPanel> createState() => _ReviewsPanelState();
}

class _ReviewsPanelState extends State<ReviewsPanel> {
  SortController sortController = SortController("created", SortOrder.descending);

  Future<List<Review>> _load(BuildContext context, String field, SortOrder order) {
    return context.read<PlacesModel>().getPlaceReviews(widget.place.id, sort: Sort(field, order));
  }

  @override
  void initState() {
    super.initState();

    sortController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<API>().getCurrentUserId();

    return FutureBuilder(
      future: _load(context, sortController.sortedBy, sortController.sortOrder),
      builder: (BuildContext context, AsyncSnapshot<List<Review>> reviews) {
        if (reviews.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReviewsRatingWidget(reviews: reviews.data!),
              Divider(height: 24),
              if (!reviews.data!.any((review) => review.user.id == currentUserId)) ...[
                Center(child: Text("Leave a review")),
                RatingField(onRatingSelected: widget.onAddReview),
                Divider(height: 10),
              ],
              if (reviews.data!.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Sort by", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SortSelector(controller: sortController),
              ],

              Expanded(
                child: ListView.separated(
                  itemCount: reviews.data!.length,
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemBuilder: (context, index) {
                    return ReviewTile(review: reviews.data![index]);
                  },
                ),
              ),
            ],
          );
        } else if (reviews.hasError) {
          return Center(child: Text(reviews.error.toString()));
        } else {
          return Skeletonizer(
            enabled: true,
            child: ListView.separated(
              itemCount: 3,
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemBuilder: (context, index) {
                return ReviewTile(
                  review: Review(
                    id: "",
                    text: "text",
                    rating: 0,
                    user: PublicUser(id: "", username: "user", avatar: null),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

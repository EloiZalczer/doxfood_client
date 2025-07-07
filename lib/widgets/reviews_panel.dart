import 'package:doxfood/api.dart';
import 'package:doxfood/models/places.dart';
import 'package:doxfood/widgets/rating.dart';
import 'package:doxfood/widgets/fields/rating_field.dart';
import 'package:doxfood/widgets/review_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum _SortedBy { rating, date }

enum _SortOrder { descending, ascending }

class ReviewsPanel extends StatefulWidget {
  final PlaceInfo place;
  final Function(int rating)? onAddReview;

  const ReviewsPanel({super.key, required this.place, this.onAddReview});

  @override
  State<ReviewsPanel> createState() => _ReviewsPanelState();
}

class _ReviewsPanelState extends State<ReviewsPanel> {
  Future<List<Review>> _load(BuildContext context) => context.read<PlacesModel>().getPlaceReviews(widget.place.id);

  _SortedBy _sortedBy = _SortedBy.date;
  _SortOrder _sortOrder = _SortOrder.descending;

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<PlacesModel>().getCurrentUserId();

    return FutureBuilder(
      future: _load(context),
      builder: (BuildContext context, AsyncSnapshot<List<Review>> reviews) {
        if (reviews.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReviewsRatingWidget(reviews: reviews.data!),
              Divider(height: 24),
              if (!reviews.data!.any((review) => review.user.id == currentUserId)) ...[
                Text("Leave a review"),
                RatingField(onRatingSelected: widget.onAddReview),
                Divider(height: 10),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Sort by", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InputChip(
                    avatar:
                        (_sortedBy == _SortedBy.date)
                            ? (_sortOrder == _SortOrder.descending)
                                ? Icon(Icons.keyboard_arrow_down)
                                : Icon(Icons.keyboard_arrow_up)
                            : null,
                    label: SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.35,
                      child: Text("Creation date", textAlign: TextAlign.center),
                    ),
                    onPressed: () {
                      setState(() {
                        _sortedBy = _SortedBy.date;
                        _sortOrder =
                            (_sortedBy == _SortedBy.rating)
                                ? _SortOrder.descending
                                : (_sortOrder == _SortOrder.ascending)
                                ? _SortOrder.descending
                                : _SortOrder.ascending;
                      });
                    },
                  ),
                  InputChip(
                    avatar:
                        (_sortedBy == _SortedBy.rating)
                            ? (_sortOrder == _SortOrder.descending)
                                ? Icon(Icons.keyboard_arrow_down)
                                : Icon(Icons.keyboard_arrow_up)
                            : null,
                    label: SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.35,
                      child: Text("Rating", textAlign: TextAlign.center),
                    ),
                    onPressed: () {
                      setState(() {
                        _sortedBy = _SortedBy.rating;
                        _sortOrder =
                            (_sortedBy == _SortedBy.date)
                                ? _SortOrder.descending
                                : (_sortOrder == _SortOrder.ascending)
                                ? _SortOrder.descending
                                : _SortOrder.ascending;
                      });
                    },
                  ),
                ],
              ),
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
                  review: Review(id: "", text: "text", rating: 0, user: User(id: "", username: "user", avatar: null)),
                );
              },
            ),
          );
        }
      },
    );
  }
}

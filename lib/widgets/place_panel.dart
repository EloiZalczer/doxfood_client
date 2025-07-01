import 'package:doxfood/api.dart';
import 'package:doxfood/models/places.dart';
import 'package:doxfood/pages/create_review.dart';
import 'package:doxfood/widgets/rating.dart';
import 'package:doxfood/widgets/rating_field.dart';
import 'package:doxfood/widgets/review_tile.dart';
import 'package:doxfood/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PlacePanel extends StatefulWidget {
  final Place place;

  const PlacePanel({super.key, required this.place});

  @override
  State<PlacePanel> createState() => _PlacePanelState();
}

class _PlacePanelState extends State<PlacePanel> {
  Future<List<Review>> _load(BuildContext context) => context.read<PlacesModel>().getPlaceReviews(widget.place.id);

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<PlacesModel>().getCurrentUserId();

    return Column(
      spacing: 10,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PlacePanelHeader(place: widget.place),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade300),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 10),
        Expanded(
          child: FutureBuilder(
            future: _load(context),
            builder: (BuildContext context, AsyncSnapshot<List<Review>> reviews) {
              if (reviews.hasData) {
                return Column(
                  children: [
                    ReviewsRatingWidget(reviews: reviews.data!),
                    Divider(height: 10),
                    if (!reviews.data!.any((review) => review.user.id == currentUserId)) ...[
                      Text("Leave a review"),
                      RatingField(
                        onRatingSelected: (int rating) {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => CreateReviewPage(rating: rating, place: widget.place),
                            ),
                          );
                        },
                      ),
                      Divider(height: 10),
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
                      return ReviewTile(review: Review(text: "text", rating: 0, user: User(id: "", username: "user")));
                    },
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class PlacePanelHeader extends StatelessWidget {
  final Place place;

  const PlacePanelHeader({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(place.name, textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        PlaceRatingWidget(place: place),
        Row(
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 10,
              children:
                  place.tags.map((tag) {
                    return DecoratedBox(
                      decoration: BoxDecoration(color: colorFromText(tag), borderRadius: BorderRadius.circular(20)),
                      child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6), child: Text(tag)),
                    );
                  }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}

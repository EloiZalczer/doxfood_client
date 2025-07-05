import 'package:doxfood/api.dart';
import 'package:doxfood/ext.dart';
import 'package:doxfood/models/place_types.dart';
import 'package:doxfood/models/places.dart';
import 'package:doxfood/widgets/rating.dart';
import 'package:doxfood/widgets/fields/rating_field.dart';
import 'package:doxfood/widgets/review_tile.dart';
import 'package:doxfood/widgets/tag_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PlacePanel extends StatefulWidget {
  final PlaceInfo place;
  final Function(int rating)? onAddReview;

  const PlacePanel({super.key, required this.place, this.onAddReview});

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
          child: Stack(
            children: [
              PlacePanelHeader(place: widget.place),
              Positioned(
                right: 60,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade300),
                  child: IconButton(
                    onPressed: () {
                      print("on pressed");
                      launchMap(widget.place.location, widget.place.name);
                    },
                    icon: Icon(Icons.navigation),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                child: Container(
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
              ),
            ],
          ),
        ),
        if (widget.place.description != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text(widget.place.description!)]),
          ),
        Divider(height: 10),
        Expanded(
          child: FutureBuilder(
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
                        Chip(
                          avatar: Icon(Icons.keyboard_arrow_down),
                          label: Text("Creation date", textAlign: TextAlign.center),
                        ),
                        Chip(
                          label: SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.38,
                            child: Text("Rating", textAlign: TextAlign.center),
                          ),
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
                        review: Review(id: "", text: "text", rating: 0, user: User(id: "", username: "user")),
                      );
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
  final PlaceInfo place;

  const PlacePanelHeader({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final placeType = context.read<PlaceTypesModel>().getById(place.type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(place.name, textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25)),
        SizedBox(height: 5),
        PlaceRatingWidget(place: place),
        Row(
          spacing: 8.0,
          children: [
            Text(placeType.name, style: TextStyle(color: Theme.of(context).hintColor)),
            Text("•", style: TextStyle(color: Theme.of(context).hintColor)),
            Text(place.price, style: TextStyle(color: Theme.of(context).hintColor)),
          ],
        ),
        Row(
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 10,
              children:
                  place.tags.map((tag) {
                    return TagChip(tag: tag);
                  }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}

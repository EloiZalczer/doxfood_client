import 'package:doxfood/models.dart';
import 'package:doxfood/pages/map/rating.dart';
import 'package:doxfood/pages/map/review_tile.dart';
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
  Future<List<Review>> _load(BuildContext context) =>
      context.read<PlacesModel>().getPlaceReviews(widget.place.id);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Column(
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.place.name,
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ),
            ],
          ),
          PlaceRatingWidget(place: widget.place),
          Row(
            children: [
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 10,
                children:
                    widget.place.tags.map((tag) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: colorFromText(tag),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 6,
                          ),
                          child: Text(tag),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: _load(context),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<Review>> reviews,
              ) {
                if (reviews.hasData) {
                  return ListView.separated(
                    itemCount: reviews.data!.length,
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemBuilder: (context, index) {
                      return ReviewTile(review: reviews.data![index]);
                    },
                  );
                } else if (reviews.hasError) {
                  return Center(child: Text("An error occurred"));
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
                            text: "text",
                            rating: 0,
                            user: User(id: "", username: "user"),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

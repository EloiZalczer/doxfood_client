import "package:doxfood/models.dart";
import "package:pocketbase/pocketbase.dart";

Future<PocketBase> connectWithPassword(uri, username, password) async {
  final pb = PocketBase(uri);

  await pb.collection("users").authWithPassword(username, password);

  return pb;
}

Future<PocketBase> connectWithToken(uri, token) async {
  var store = AuthStore();
  store.save(token, RecordModel({"verified": false}));

  final pb = PocketBase(uri, authStore: store);

  await pb.collection("users").authRefresh();

  return pb;
}

Future<List<Place>> getPlaces(PocketBase pb) async {
  final places = await pb
      .collection("restaurants")
      .getList(
        expand: "tags,reviews_via_restaurant",
        fields:
            "id, name, latitude, longitude, price, expand.tags, expand.reviews_via_restaurant.rating",
      );

  return places.items.map((record) {
    return Place.fromRecord(record);
  }).toList();
}

Future<List<Review>> getReviews(PocketBase pb, String placeId) async {
  final reviews = await pb
      .collection("reviews")
      .getFullList(
        filter: pb.filter("restaurant ~ {:id}", {"id": placeId}),
        expand: "user",
        sort: "-created",
      );

  return reviews
      .map((record) {
        return Review.fromRecord(record);
      })
      .toList(growable: false);
}

import "package:pocketbase/pocketbase.dart";

class Place {
  Place({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.price,
    required this.ratings,
    required this.tags,
    required this.type,
  });

  final String? id;
  final String name;
  final double latitude;
  final double longitude;
  final String price;
  final List<int> ratings;
  final List<String> tags;
  final String type;

  double get averageRating {
    return ratings.isNotEmpty ? ratings.reduce((a, b) => a + b) / ratings.length : 0;
  }

  factory Place.fromRecord(RecordModel record) {
    return Place(
      id: record.get<String>("id"),
      name: record.get<String>("name"),
      latitude: record.get<double>("latitude"),
      longitude: record.get<double>("longitude"),
      price: record.get<String>("price"),
      tags: record.get<List<RecordModel>>("expand.tags").map((tag) => tag.get<String>("name")).toList(),
      ratings:
          record.get<List<RecordModel>>("expand.reviews_via_place").map((review) => review.get<int>("rating")).toList(),
      type: record.get<RecordModel>("expand.type").get<String>("name"),
    );
  }

  Map<String, dynamic> toRecord() {
    return {
      "id": id,
      "name": name,
      "latitude": latitude,
      "longitude": longitude,
      "price": price,
      "tags": tags,
      "type": type,
    };
  }

  @override
  String toString() {
    return "Place(id=$id, name=$name, latitude=$latitude, longitude=$longitude, price=$price, ratings=$ratings, tags=$tags, type=$type)";
  }
}

class Review {
  Review({required this.text, required this.rating, required this.user});

  final String text;
  final int rating;
  final User user;

  factory Review.fromRecord(RecordModel record) {
    return Review(
      text: record.get<String>("text"),
      rating: record.get<int>("rating"),
      user: User.fromRecord(record.get<RecordModel>("expand.user")),
    );
  }

  @override
  String toString() {
    return "Review(text=$text, rating=$rating, user=$user)";
  }
}

class User {
  User({required this.id, required this.username});

  final String id;
  final String username;

  factory User.fromRecord(RecordModel record) {
    return User(id: record.get<String>("id"), username: record.get<String>("username"));
  }

  @override
  String toString() {
    return "User(id=$id, username=$username)";
  }
}

class Tag {
  Tag({required this.id, required this.name});

  final String id;
  final String name;

  factory Tag.fromRecord(RecordModel record) {
    return Tag(id: record.get<String>("id"), name: record.get<String>("name"));
  }

  @override
  String toString() {
    return "Tag(id=$id, name=$name)";
  }
}

class PlaceType {
  PlaceType({required this.id, required this.name, required this.icon});

  final String id;
  final String name;
  final String icon;

  factory PlaceType.fromRecord(RecordModel record) {
    return PlaceType(id: record.get<String>("id"), name: record.get<String>("name"), icon: record.get<String>("icon"));
  }

  @override
  String toString() {
    return "PlaceType(id=$id, name=$name, icon=$icon)";
  }
}

class ConnectionFailed implements Exception {}

class API {
  final PocketBase _pb;

  API._(this._pb);

  PocketBase get pb => _pb;

  static Future<API> createAccountAndConnect(
    String uri,
    String username,
    String password,
    String passwordConfirm,
  ) async {
    final pb = PocketBase(uri);

    await pb
        .collection("users")
        .create(body: {"username": username, "password": password, "passwordConfirm": passwordConfirm});

    return API.connectWithPassword(uri, username, password);
  }

  static Future<API> connectWithPassword(String uri, String username, String password) async {
    final pb = PocketBase(uri);

    try {
      await pb.collection("users").authWithPassword(username, password);
    } on ClientException catch (e) {
      if (e.statusCode == 400) throw ConnectionFailed();
    }

    return API._(pb);
  }

  static Future<API> connectWithToken(String uri, String token) async {
    var store = AuthStore();
    store.save(token, RecordModel({"verified": false}));

    final pb = PocketBase(uri, authStore: store);

    await pb.collection("users").authRefresh();

    return API._(pb);
  }

  Future<List<Place>> getPlaces() async {
    final places = await _pb
        .collection("places")
        .getList(
          expand: "tags,reviews_via_place",
          fields: "id, name, latitude, longitude, price, expand.tags, expand.reviews_via_place.rating",
        );

    return places.items.map((record) {
      return Place.fromRecord(record);
    }).toList();
  }

  Future<List<Review>> getReviews(String placeId) async {
    final reviews = await _pb
        .collection("reviews")
        .getFullList(filter: _pb.filter("place ~ {:id}", {"id": placeId}), expand: "user", sort: "-created");

    return reviews.map((record) {
      return Review.fromRecord(record);
    }).toList();
  }

  Future<List<Tag>> getTags() async {
    final tags = await _pb.collection("tags").getFullList();

    return tags.map((record) {
      return Tag.fromRecord(record);
    }).toList();
  }

  Future<List<PlaceType>> getPlaceTypes() async {
    final tags = await _pb.collection("place_types").getFullList();

    return tags.map((record) {
      return PlaceType.fromRecord(record);
    }).toList();
  }
}

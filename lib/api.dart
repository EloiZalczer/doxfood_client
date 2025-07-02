import "package:latlong2/latlong.dart";
import "package:pocketbase/pocketbase.dart";

class Place {
  Place({
    this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.tags,
    required this.type,
    this.googleMapsLink,
    this.description,
  });

  final String? id;
  final String name;
  final LatLng location;
  final String price;
  final List<Tag> tags;
  final String type;
  final String? googleMapsLink;
  final String? description;

  factory Place.fromRecord(RecordModel record) {
    final location = record.get<Map>("location");

    return Place(
      id: record.get<String>("id"),
      name: record.get<String>("name"),
      location: LatLng(location["lat"], location["lon"]),
      price: record.get<String>("price"),
      tags: record.get<List<RecordModel>>("expand.tags").map((tag) => Tag.fromRecord(tag)).toList(),
      type: record.get<String>("type"),
      googleMapsLink: record.get<String?>("googleMapsLink"),
      description: record.get<String?>("description"),
    );
  }

  Map<String, dynamic> toRecord() {
    return {
      "id": id,
      "name": name,
      "location": {"lat": location.latitude, "lon": location.longitude},
      "price": price,
      "tags": tags.map((tag) => tag.id).toList(),
      "type": type,
      "googleMapsLink": googleMapsLink,
      "description": description,
    };
  }

  @override
  String toString() {
    return "Place(id=$id, name=$name, location=$location, price=$price, tags=$tags, type=$type)";
  }
}

class PlaceInfo {
  final Place place;
  final List<int> ratings;

  PlaceInfo._(this.place, this.ratings);

  String? get id => place.id;
  String get name => place.name;
  LatLng get location => place.location;
  String get price => place.price;
  String get type => place.type;
  List<Tag> get tags => place.tags;
  String? get description => place.description;

  double get averageRating {
    return ratings.isNotEmpty ? ratings.reduce((a, b) => a + b) / ratings.length : 0;
  }

  factory PlaceInfo.fromRecord(RecordModel record) {
    return PlaceInfo._(
      Place.fromRecord(record),
      record.get<List<RecordModel>>("expand.reviews_via_place").map((review) => review.get<int>("rating")).toList(),
    );
  }
}

class Review {
  Review({this.id, required this.text, required this.rating, required this.user});

  final String? id;
  final String text;
  final int rating;
  final User user;

  factory Review.fromRecord(RecordModel record) {
    return Review(
      id: record.get<String>("id"),
      text: record.get<String>("text"),
      rating: record.get<int>("rating"),
      user: User.fromRecord(record.get<RecordModel>("expand.user")),
    );
  }

  Map<String, dynamic> toRecord() {
    return {"id": id, "text": text, "rating": rating, "user": user.id};
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

  Future<List<PlaceInfo>> getPlaces() async {
    final places = await _pb
        .collection("places")
        .getList(
          expand: "tags,reviews_via_place",
          fields: "id, name, location, price, type, expand.tags, expand.reviews_via_place.rating",
        );

    return places.items.map((record) {
      return PlaceInfo.fromRecord(record);
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

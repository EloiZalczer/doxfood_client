import "package:doxfood/http_errors.dart";
import "package:doxfood/widgets/filter_editor.dart";
import "package:latlong2/latlong.dart";
import "package:pocketbase/pocketbase.dart";

typedef ID = String;

enum SortOrder { descending, ascending }

class Sort {
  String field;
  SortOrder order;

  Sort(this.field, this.order);

  String toSortString() {
    if (order == SortOrder.descending) {
      return "-$field";
    } else {
      return field;
    }
  }
}

class Place {
  Place({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.tags,
    required this.type,
    this.googleMapsLink,
    this.description,
  });

  final ID id;
  final String name;
  final LatLng location;
  final String price; // FIXME this shouldn't be a string
  final List<Tag> tags;
  final ID type;
  final String? googleMapsLink;
  final String? description;

  factory Place.fromRecord(RecordModel record) {
    final location = record.get<Map>("location");

    return Place(
      id: record.get<ID>("id"),
      name: record.get<String>("name"),
      location: LatLng(location["lat"], location["lon"]),
      price: record.get<String>("price"),
      tags: record.get<List<RecordModel>>("expand.tags").map((tag) => Tag.fromRecord(tag)).toList(),
      type: record.get<ID>("type"),
      googleMapsLink: record.get<String?>("googleMapsLink"),
      description: record.get<String?>("description"),
    );
  }

  @override
  String toString() {
    return "Place(id=$id, name=$name, location=$location, price=$price, tags=$tags, type=$type)";
  }

  Map asMap() {
    return {
      "id": id,
      "name": name,
      "location": {"latitude": location.latitude, "longitude": location.longitude},
      "price": price,
      "tags": tags.map((tag) => {"name": tag.name, "id": tag.id}),
      "type": type,
      "googleMapsLink": googleMapsLink,
      "description": description,
    };
  }
}

class PlaceInfo {
  final Place place;
  final List<int> ratings;

  PlaceInfo._(this.place, this.ratings);

  ID get id => place.id;
  String get name => place.name;
  LatLng get location => place.location;
  String get price => place.price;
  ID get type => place.type;
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
  Review({required this.id, required this.text, required this.rating, required this.user});

  final ID id;
  final String text;
  final int rating;
  final PublicUser user;

  @override
  String toString() {
    return "Review(text=$text, rating=$rating, user=$user)";
  }
}

class PublicUser {
  PublicUser({required this.id, required this.username, this.avatar});

  final ID id;
  final String username;
  final String? avatar;

  @override
  String toString() {
    return "User(id=$id, username=$username, avatar=$avatar)";
  }
}

class Tag {
  Tag({required this.id, required this.name, required this.placeType});

  final ID id;
  final String name;
  final ID placeType;

  factory Tag.fromRecord(RecordModel record) {
    return Tag(id: record.get<ID>("id"), name: record.get<String>("name"), placeType: record.get<ID>("placeType"));
  }

  @override
  String toString() {
    return "Tag(id=$id, name=$name, placeType=$placeType)";
  }
}

class Filter {
  final ID id;
  final bool priceRangeEnabled;
  final bool includeTagsEnabled;
  final bool excludeTagsEnabled;
  final bool includePlacesEnabled;
  final bool excludePlacesEnabled;
  final ID placeType;
  final String lowerPriceBound; // FIXME using strings here is terrible
  final String upperPriceBound;
  final List<ID> includedTags;
  final List<ID> excludedTags;
  final List<ID> includedPlaces;
  final List<ID> excludedPlaces;
  final ID user;
  final String name;

  Filter({
    required this.id,
    required this.priceRangeEnabled,
    required this.includeTagsEnabled,
    required this.excludeTagsEnabled,
    required this.includePlacesEnabled,
    required this.excludePlacesEnabled,
    required this.placeType,
    required this.lowerPriceBound,
    required this.upperPriceBound,
    required this.includedTags,
    required this.excludedTags,
    required this.includedPlaces,
    required this.excludedPlaces,
    required this.user,
    required this.name,
  });

  factory Filter.fromRecord(RecordModel record) {
    return Filter(
      id: record.get<String>("id"),
      priceRangeEnabled: record.get("priceRangeEnabled"),
      includeTagsEnabled: record.get("includeTagsEnabled"),
      excludeTagsEnabled: record.get("excludeTagsEnabled"),
      includePlacesEnabled: record.get("includePlacesEnabled"),
      excludePlacesEnabled: record.get("excludePlacesEnabled"),
      placeType: record.get("placeType"),
      lowerPriceBound: record.get("lowerPriceBound"),
      upperPriceBound: record.get("upperPriceBound"),
      includedTags: record.get("includedTags"),
      excludedTags: record.get("excludedTags"),
      includedPlaces: record.get("includedPlaces"),
      excludedPlaces: record.get("excludedPlaces"),
      user: record.get("user"),
      name: record.get("name"),
    );
  }

  FilterConfiguration get configuration => FilterConfiguration(
    priceRangeEnabled: priceRangeEnabled,
    includeTagsEnabled: includeTagsEnabled,
    excludeTagsEnabled: excludeTagsEnabled,
    includePlacesEnabled: includePlacesEnabled,
    excludePlacesEnabled: excludePlacesEnabled,
    placeType: placeType,
    lowerPriceBound: lowerPriceBound,
    upperPriceBound: upperPriceBound,
    includedTags: includedTags,
    excludedTags: excludedTags,
    includedPlaces: includedPlaces,
    excludedPlaces: excludedPlaces,
  );

  @override
  String toString() {
    return "Filter(id=$id, name=$name, priceRangeEnabled=$priceRangeEnabled, includeTagsEnabled=$includeTagsEnabled, excludeTagsEnabled=$excludeTagsEnabled, includePlacesEnabled=$includePlacesEnabled, excludePlacesEnabled=$excludePlacesEnabled, placeType=$placeType, lowerPriceBound=$lowerPriceBound, upperPriceBound=$upperPriceBound, includedTags=$includedTags, excludedTags=$excludedTags, includedPlaces=$includedPlaces, excludedPlaces=$excludedPlaces, user=$user)";
  }
}

class PlaceType {
  PlaceType({required this.id, required this.name, required this.icon});

  final ID id;
  final String name;
  final String icon;

  factory PlaceType.fromRecord(RecordModel record) {
    return PlaceType(id: record.get<ID>("id"), name: record.get<String>("name"), icon: record.get<String>("icon"));
  }

  @override
  String toString() {
    return "PlaceType(id=$id, name=$name, icon=$icon)";
  }
}

class ServerInfo {
  ServerInfo({required this.id, required this.description});

  final ID id;
  final String description;

  factory ServerInfo.fromRecord(RecordModel record) {
    return ServerInfo(id: record.get<ID>("id"), description: record.get<String>("description"));
  }
}

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
      reraise(e);
    }

    return API._(pb);
  }

  static Future<API> connectWithToken(String uri, String token) async {
    var store = AuthStore();
    store.save(token, RecordModel({"verified": false}));

    final pb = PocketBase(uri, authStore: store);

    try {
      await pb.collection("users").authRefresh();
    } on ClientException catch (e) {
      reraise(e);
    }

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

  Future<List<Review>> getReviews(String placeId, {Sort? sort}) async {
    // FIXME reviews reference the 'users' collection, which is not accessible
    // to other users for confidentiality reasons. We get the user name and
    // avatar from the public_users view instead, but pocketbase doesn't allow
    // this kind of joins through the web API. Therefore, we have to perform two
    // requests (one to get reviews, the other one to get users), and then
    // reconcile them together. A better solution would be welcome, but it does
    // not seem to exist.
    // https://github.com/pocketbase/pocketbase/discussions/4188

    final String? sortParam = (sort != null) ? sort.toSortString() : null;

    final reviews = await _pb
        .collection("reviews")
        .getFullList(filter: _pb.filter("place ~ {:id}", {"id": placeId}), sort: sortParam);

    final userIds = reviews.map((record) => record.get<String>("user"));

    final filter = userIds.map((e) => "id = '$e'").join(" || ");

    final users = await _pb.collection("public_users").getFullList(filter: filter);

    final Map<String, PublicUser> usersMap = {
      for (var v in users)
        v.get<String>("id"): PublicUser(
          id: v.get<ID>("id"),
          username: v.get<String>("username"),
          avatar: v.get<String?>("avatar"),
        ),
    };

    return reviews.map((record) {
      return Review(
        id: record.get<ID>("id"),
        text: record.get<String>("text"),
        rating: record.get<int>("rating"),
        user: usersMap[record.get("user")]!,
      );
    }).toList();
  }

  Future<List<Tag>> getTags() async {
    final tags = await _pb.collection("tags").getFullList();

    return tags.map((record) {
      return Tag.fromRecord(record);
    }).toList();
  }

  Future<List<Filter>> getFilters() async {
    final filters = await _pb.collection("filters").getFullList();

    return filters.map((record) {
      return Filter.fromRecord(record);
    }).toList();
  }

  Future<List<PlaceType>> getPlaceTypes() async {
    final tags = await _pb.collection("place_types").getFullList();

    return tags.map((record) {
      return PlaceType.fromRecord(record);
    }).toList();
  }

  Future<ServerInfo> getServerInfo() async {
    return _pb.collection("server").getList(perPage: 1).then((result) {
      if (result.items.isEmpty) {
        throw BadRequest();
      }
      return ServerInfo.fromRecord(result.items[0]);
    });
  }

  Future<List<PublicUser>> getPublicUsers() async {
    return _pb.collection("public_users").getFullList().then((result) {
      if (result.isEmpty) {
        throw BadRequest();
      }

      return result.map((r) {
        return PublicUser(id: r.get<ID>("id"), username: r.get<String>("username"), avatar: r.get<String?>("avatar"));
      }).toList();
    });
  }

  Uri? getAvatarURL(PublicUser user) {
    if (user.avatar == null || user.avatar!.isEmpty) return null;

    return _pb.buildURL(
      "/api/files/${Uri.encodeComponent("public_users")}/${Uri.encodeComponent(user.id)}/${Uri.encodeComponent(user.avatar!)}",
    );
  }

  String getCurrentUserId() {
    return _pb.authStore.record!.get<String>("id");
  }
}

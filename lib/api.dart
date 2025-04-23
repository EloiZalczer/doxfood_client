import "package:doxfood/models.dart";
import "package:pocketbase/pocketbase.dart";

Future<PocketBase> connect(uri, username, password) async {
  final pb = PocketBase(uri);

  await pb.collection("users").authWithPassword(username, password);

  return pb;
}

Future<List<Place>> getPlaces(PocketBase pb) async {
  final places = await pb.collection("restaurants").getList();

  return places.items.map((record) => Place.fromRecord(record)).toList();
}

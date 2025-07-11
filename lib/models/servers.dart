import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ServersListModel extends ChangeNotifier {
  final Database _db;

  final List<Server> _servers = [];

  UnmodifiableListView<Server> get servers => UnmodifiableListView(_servers);

  ServersListModel._(this._db);

  static Future<ServersListModel> open() async {
    WidgetsFlutterBinding.ensureInitialized();

    final db = await openDatabase(
      join(await getDatabasesPath(), "doxfood_database.db"),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE servers(id INTEGER PRIMARY KEY, name TEXT UNIQUE, uri TEXT, token TEXT)");
      },
      version: 1,
    );

    return ServersListModel._(db);
  }

  Future<void> load() async {
    _servers.addAll((await _db.query("servers")).map((e) => Server.fromRecord(e)));
  }

  Server? getByName(String name) {
    return _servers.cast<Server?>().firstWhere((e) => e!.name == name, orElse: () => null);
  }

  Future<void> add(String name, String uri, String token) async {
    final id = await _db.insert("servers", {"name": name, "uri": uri, "token": token});
    final server = Server(id: id, name: name, uri: uri, token: token);
    _servers.add(server);
    notifyListeners();
  }

  Future<void> remove(int id) async {
    await _db.delete("servers", where: "id = ?", whereArgs: [id]);
    _servers.removeWhere((Server s) => s.id == id);
    notifyListeners();
  }

  Future<void> update(int id, String name, String uri, String token) async {
    await _db.update("servers", {"name": name, "uri": uri, "token": token}, where: "id = ?", whereArgs: [id]);
    final index = _servers.indexWhere((Server s) => s.id == id);
    _servers[index] = Server(id: id, name: name, uri: uri, token: token);
    notifyListeners();
  }
}

class Server {
  Server({required this.id, required this.name, required this.uri, required this.token});

  final int id;
  final String name;
  final String uri;
  final String token;

  factory Server.fromRecord(Map<String, Object?> record) {
    return Server(
      id: record["id"] as int,
      name: record["name"] as String,
      uri: record["uri"] as String,
      token: record["token"] as String,
    );
  }

  Map<String, Object?> toRecord() {
    return {"id": id, "name": name, "uri": uri, "token": token};
  }
}

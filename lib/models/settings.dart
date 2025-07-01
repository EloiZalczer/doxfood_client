import 'package:shared_preferences/shared_preferences.dart';

const _currentServerKey = 'current_server';

class Settings {
  final SharedPreferences _prefs;

  Settings._(this._prefs);

  static Future<Settings> load() async {
    return Settings._(await SharedPreferences.getInstance());
  }

  String? get currentServer => _prefs.getString(_currentServerKey);

  set currentServer(String? server) {
    if (server == null) {
      _prefs.remove(_currentServerKey);
    } else {
      _prefs.setString(_currentServerKey, server);
    }
  }
}

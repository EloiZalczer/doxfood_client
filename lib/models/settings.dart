import 'package:shared_preferences/shared_preferences.dart';

// TODO use this for actual settings

class Settings {
  final SharedPreferences _prefs;

  Settings._(this._prefs);

  static Future<Settings> load() async {
    return Settings._(await SharedPreferences.getInstance());
  }
}

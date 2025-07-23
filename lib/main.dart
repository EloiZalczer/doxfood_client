import 'package:doxfood/api.dart';
import 'package:doxfood/app.dart';
import 'package:doxfood/http_errors.dart';
import 'package:doxfood/models/location.dart';
import 'package:doxfood/models/random_config.dart';
import 'package:doxfood/models/servers.dart';
import 'package:doxfood/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: true,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();

  ServersModel servers = await ServersModel.open();
  await servers.load();

  Settings settings = await Settings.load();

  final location = LocationModel();
  await location.init();

  final Server? server = (servers.currentServer == null) ? null : servers.getById(servers.currentServer!);

  API? api;

  if (server == null) {
    api = null;
  } else {
    try {
      api = await API.connectWithToken(server.uri, server.token);
    } on Unauthorized {
      api = null;
      servers.currentServer = null;
    }
  }

  final randomConfiguration = await RandomConfigurationModel.open();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ServersModel>.value(value: servers),
        ChangeNotifierProvider<RandomConfigurationModel>.value(value: randomConfiguration),
        Provider<Settings>.value(value: settings),
        Provider<LocationModel>.value(value: location),
      ],
      child: App(initialAPI: api),
    ),
  );
}

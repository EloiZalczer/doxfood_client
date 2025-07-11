import 'package:doxfood/api.dart';
import 'package:doxfood/app.dart';
import 'package:doxfood/models/location.dart';
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

  ServersListModel serversList = await ServersListModel.open();
  await serversList.load();

  Settings settings = await Settings.load();

  settings.currentServer;

  final Server? server = (settings.currentServer == null) ? null : serversList.getByName(settings.currentServer!);

  final API? api = (server == null) ? null : await API.connectWithToken(server.uri, server.token!);

  // final location = LocationProvider();
  // await location.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ServersListModel>.value(value: serversList),
        // ChangeNotifierProvider<LocationProvider>.value(value: location),
        Provider<Settings>.value(value: settings),
      ],
      child: App(initialAPI: api),
    ),
  );
}

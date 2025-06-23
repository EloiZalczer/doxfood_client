import 'package:doxfood/app.dart';
import 'package:doxfood/database.dart';
import 'package:doxfood/models.dart';
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

  ServersListModel serversList = ServersListModel();

  serversList.add(
    Server(name: "Test", uri: "https://pocketbase-doxfood.zalczer.fr"),
  );

  PlacesModel placesList = PlacesModel();

  placesList.connect(
    serversList.servers[0],
    "eloi",
    "V€ndr3diRégu1ièr€m€nt@pp5tor3",
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ServersListModel>.value(value: serversList),
        ChangeNotifierProvider<PlacesModel>.value(value: placesList),
      ],
      child: App(),
    ),
  );
}

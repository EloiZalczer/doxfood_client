import 'package:doxfood/home.dart';
import 'package:doxfood/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ChangeNotifierProvider<PlacesModel>(
        create: (context) {
          return PlacesModel(
            uri: "https://pocketbase-doxfood.zalczer.fr",
            username: "eloi",
            password: "V€ndr3diRégu1ièr€m€nt@pp5tor3",
          );
        },
        child: MyHomePage(),
      ),
    );
  }
}

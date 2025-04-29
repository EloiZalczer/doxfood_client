import 'package:doxfood/database.dart';
import 'package:doxfood/pages/servers/server_tile.dart';
import 'package:flutter/material.dart';

class ServersPage extends StatelessWidget {
  ServersPage({super.key});

  final List<Server> servers = [
    Server(name: "Test", uri: "https://pocketbase-doxfood.zalczer.fr"),
  ];

  void onServerSelected(Server s) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: servers.length,
        itemBuilder: (context, index) {
          return ServerTile(server: servers[index], onTap: onServerSelected);
        },
      ),
    );
  }
}

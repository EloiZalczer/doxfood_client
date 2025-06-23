import 'package:doxfood/database.dart';
import 'package:doxfood/dialogs/add_server.dart';
import 'package:doxfood/models.dart';
import 'package:doxfood/pages/servers/server_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServersPage extends StatelessWidget {
  const ServersPage({super.key});

  void onServerSelected(Server s) {}

  @override
  Widget build(BuildContext context) {
    var serversList = context.read<ServersListModel>();

    return Scaffold(
      appBar: AppBar(title: Text("Servers")),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: serversList.servers.length,
        itemBuilder: (context, index) {
          return ServerTile(
            server: serversList.servers[index],
            onTap: onServerSelected,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddServerDialog.show(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

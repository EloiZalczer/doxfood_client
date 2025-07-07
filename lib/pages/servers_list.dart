import 'package:doxfood/api.dart';
import 'package:doxfood/pages/add_server.dart';
import 'package:doxfood/models/servers.dart';
import 'package:doxfood/models/settings.dart';
import 'package:doxfood/pages/server_details.dart';
import 'package:doxfood/widgets/loader_overlay.dart';
import 'package:doxfood/widgets/server_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ServersListPage extends StatefulWidget {
  const ServersListPage({super.key});

  @override
  State<ServersListPage> createState() => _ServersListPageState();
}

class _ServersListPageState extends State<ServersListPage> {
  bool _loading = false;

  void onServerSelected(BuildContext context, Server s) async {
    context.read<Settings>().currentServer = s.name;

    setState(() {
      _loading = true;
    });

    final API api = await API.connectWithToken(s.uri, s.token!);

    print("continue");

    GoRouter.of(context).go("/home", extra: api);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var serversList = context.watch<ServersListModel>();

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text("Servers")),
          body: ListView.builder(
            itemCount: serversList.servers.length,
            itemBuilder: (context, index) {
              return ServerTile(
                server: serversList.servers[index],
                onTap: (server) => onServerSelected(context, server),
                onLongPress: (server) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ServerDetailsPage(server: server)));
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddServerPage()));
            },
            child: Icon(Icons.add),
          ),
        ),
        if (_loading) LoaderOverlay(),
      ],
    );
  }
}

import 'package:doxfood/api.dart';
import 'package:doxfood/dialogs/connection_expired.dart';
import 'package:doxfood/http_errors.dart';
import 'package:doxfood/pages/add_server.dart';
import 'package:doxfood/models/servers.dart';
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
    final servers = context.read<ServersModel>();

    setState(() {
      _loading = true;
    });

    API? api;

    try {
      api = await API.connectWithToken(s.uri, s.token);
    } on Unauthorized {
      while (true) {
        final password = await ConnectionExpiredDialog.show(context, s);
        if (password == null) {
          setState(() {
            _loading = false;
          });
          return;
        }

        try {
          api = await API.connectWithPassword(s.uri, s.username, password);
        } on Unauthorized {
          continue;
        }

        servers.update(s.id, s.name, s.uri, s.username, api.pb.authStore.token);
        break;
      }
    }

    servers.currentServer = s.id;

    if (context.mounted) {
      GoRouter.of(context).go("/home", extra: api);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = context.read<ServersModel>().currentServer;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text("Servers")),
          body: Consumer<ServersModel>(
            builder: (context, value, child) {
              return ListView.builder(
                itemCount: value.servers.length,
                itemBuilder: (context, index) {
                  return ServerTile(
                    isCurrent: current == value.servers[index].id,
                    server: value.servers[index],
                    onTap: (server) => onServerSelected(context, server),
                    onLongPress: (server) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ServerDetailsPage(server: server)),
                      );
                    },
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddServerPage()));
            },
            child: const Icon(Icons.add),
          ),
        ),
        if (_loading) const LoaderOverlay(),
      ],
    );
  }
}

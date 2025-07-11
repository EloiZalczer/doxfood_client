import 'package:doxfood/api.dart';
import 'package:doxfood/dialogs/confirm_remove_server.dart';
import 'package:doxfood/models/servers.dart';
import 'package:doxfood/models/settings.dart';
import 'package:doxfood/pages/edit_server.dart';
import 'package:doxfood/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ServerDisconnected implements Exception {}

class _ServerDetails {
  final ServerInfo info;
  final List<PublicUser> users;

  _ServerDetails(this.info, this.users);
}

class ServerDetailsPage extends StatelessWidget {
  final Server server;

  const ServerDetailsPage({super.key, required this.server});

  Future<_ServerDetails> _load() async {
    final api = await API.connectWithToken(server.uri, server.token);
    final info = await api.getServerInfo();
    final users = await api.getPublicUsers();

    return _ServerDetails(info, users);
  }

  void _onEdit(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditServerPage(server: server)));
  }

  void _onDelete(BuildContext context) async {
    final result = await ConfirmRemoveServerDialog.show(context, server);

    if (result == true && context.mounted) {
      final serversList = context.read<ServersListModel>();
      final settings = context.read<Settings>();

      serversList.remove(server.id);

      if (settings.currentServer == server.name) {
        settings.currentServer = null;
        GoRouter.of(context).go("/servers");
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final you = context.read<API>().getCurrentUserId();

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(server.name),
          actions: [
            IconButton(onPressed: () => _onEdit(context), icon: Icon(Icons.edit)),
            IconButton(onPressed: () => _onDelete(context), icon: Icon(Icons.delete)),
          ],
        ),
        body: FutureBuilder(
          future: _load(),
          builder: (BuildContext context, AsyncSnapshot<_ServerDetails> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Text(snapshot.data!.info.description),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Text("${snapshot.data!.users.length} user(s)", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.users.length,
                      itemBuilder: (context, index) {
                        final user = snapshot.data!.users[index];

                        return ListTile(
                          leading: UserAvatar(user: user),
                          title: Text(snapshot.data!.users[index].username),
                          trailing: (user.id == you) ? Text("You") : null,
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Center(child: Text("Loading..."));
            }
          },
        ),
      ),
    );
  }
}

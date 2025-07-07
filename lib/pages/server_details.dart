import 'package:doxfood/api.dart';
import 'package:doxfood/models/servers.dart';
import 'package:doxfood/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class ServerDisconnected implements Exception {}

class _ServerDetails {
  final ServerInfo info;
  final List<User> users;

  _ServerDetails(this.info, this.users);
}

class ServerDetailsPage extends StatelessWidget {
  final Server server;

  const ServerDetailsPage({super.key, required this.server});

  Future<_ServerDetails> _load() async {
    if (server.token == null) {
      throw ServerDisconnected();
    } else {
      final api = await API.connectWithToken(server.uri, server.token!);
      final info = await api.getServerInfo();
      final users = await api.getPublicUsers();

      return _ServerDetails(info, users);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(server.name),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
            IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
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

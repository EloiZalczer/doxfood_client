import 'package:doxfood/database.dart';
import 'package:flutter/material.dart';

class ServerTile extends StatelessWidget {
  final Server server;
  final Function(Server s) onTap;

  const ServerTile({super.key, required this.server, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(server.name),
        subtitle: Text(server.uri),
        onTap: () => onTap(server),
        trailing: Icon(Icons.circle, color: Colors.green, size: 12.0),
      ),
    );
  }
}

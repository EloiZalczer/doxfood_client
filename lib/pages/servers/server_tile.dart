import 'package:doxfood/database.dart';
import 'package:flutter/material.dart';

class ServerTile extends StatelessWidget {
  final Server server;
  final Function(Server s) onTap;

  const ServerTile({super.key, required this.server, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: ContinuousRectangleBorder(
        side: BorderSide(color: Colors.black, width: 1),
      ),
      title: Text(server.name),
      onTap: () => onTap(server),
    );
  }
}

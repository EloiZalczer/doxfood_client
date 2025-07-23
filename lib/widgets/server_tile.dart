import 'package:doxfood/models/servers.dart';
import 'package:flutter/material.dart';

class ServerTile extends StatelessWidget {
  final Server server;
  final bool isCurrent;
  final Function(Server s) onTap;
  final Function(Server s)? onLongPress;

  const ServerTile({super.key, required this.server, required this.onTap, this.onLongPress, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(server.name),
        subtitle: Text(server.uri),
        onTap: () => onTap(server),
        trailing: isCurrent ? const Icon(Icons.circle, color: Colors.green, size: 12.0) : null,
        onLongPress: () {
          if (onLongPress != null) onLongPress!(server);
        },
      ),
    );
  }
}

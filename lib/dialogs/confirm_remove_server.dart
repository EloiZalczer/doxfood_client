import 'package:doxfood/models/servers.dart';
import 'package:flutter/material.dart';

class ConfirmRemoveServerDialog extends StatelessWidget {
  final Server server;

  const ConfirmRemoveServerDialog({super.key, required this.server});

  static Future<bool?> show(BuildContext context, Server server) {
    return showDialog(
      context: context,
      builder: (context) {
        return ConfirmRemoveServerDialog(server: server);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Remove server"),
      content: Text(
        "Do you really want to remove ${server.name} from the list ? You will need to connect again to access it.",
      ),
      actions: [
        TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(context)),
        ElevatedButton(child: const Text("Remove"), onPressed: () => Navigator.pop(context, true)),
      ],
    );
  }
}

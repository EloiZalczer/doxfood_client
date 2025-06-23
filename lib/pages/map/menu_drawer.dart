import 'package:flutter/material.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text("Menu"),
          ),
          ListTile(leading: Icon(Icons.settings), title: Text("Settings")),
          ListTile(leading: Icon(Icons.info), title: Text("About")),
        ],
      ),
    );
  }
}

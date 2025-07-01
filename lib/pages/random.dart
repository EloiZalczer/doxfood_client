import 'package:doxfood/models/tags.dart';
import 'package:doxfood/pages/random_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RandomPage extends StatelessWidget {
  const RandomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TagsModel tags = context.read<TagsModel>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(child: Text("Get random place"), onPressed: () => {}),
            TextButton.icon(
              label: const Text("Configure"),
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            ChangeNotifierProvider<TagsModel>.value(value: tags, child: const RandomSettingsPage()),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

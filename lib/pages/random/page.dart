import 'package:doxfood/pages/random/random_settings.dart';
import 'package:flutter/material.dart';

class RandomPage extends StatelessWidget {
  const RandomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Get random restaurant"),
              onPressed: () => {},
            ),
            TextButton.icon(
              label: const Text("Configure"),
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RandomSettingsPage(),
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

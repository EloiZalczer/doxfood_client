import 'package:doxfood/pages/filters_list.dart';
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
            ElevatedButton(child: Text("Get random place"), onPressed: () => {}),
            TextButton.icon(
              label: const Text("Configure"),
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FiltersListPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

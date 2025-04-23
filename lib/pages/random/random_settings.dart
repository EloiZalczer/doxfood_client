import 'package:flutter/material.dart';

class RandomSettingsPage extends StatelessWidget {
  const RandomSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: ElevatedButton(onPressed: () {}, child: Text("Test")),
      ),
    );
  }
}

import 'package:doxfood/pages/edit_filter.dart';
import 'package:doxfood/widgets/filter_tile.dart';
import 'package:flutter/material.dart';

class FiltersListPage extends StatelessWidget {
  const FiltersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Filters")),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return FilterTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditFilterPage()));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditFilterPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

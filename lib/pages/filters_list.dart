import 'package:doxfood/models/filters.dart';
import 'package:doxfood/pages/edit_filter.dart';
import 'package:doxfood/widgets/filter_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FiltersListPage extends StatefulWidget {
  const FiltersListPage({super.key});

  @override
  State<FiltersListPage> createState() => _FiltersListPageState();
}

class _FiltersListPageState extends State<FiltersListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filters")),
      body: Consumer<FiltersModel>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.filters.length,
            itemBuilder: (context, index) {
              return FilterTile(
                filter: value.filters[index],
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => EditFilterPage(filter: value.filters[index])));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditFilterPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:doxfood/api.dart';
import 'package:doxfood/models/random_config.dart';
import 'package:doxfood/widgets/filter_summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterTile extends StatefulWidget {
  final Filter filter;
  final Function onTap;

  const FilterTile({super.key, required this.filter, required this.onTap});

  @override
  State<FilterTile> createState() => _FilterTileState();
}

class _FilterTileState extends State<FilterTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Consumer<RandomConfigurationModel>(
        builder: (context, value, child) {
          return Checkbox(
            value: value.selectedFilters.contains(widget.filter.id),
            onChanged: (v) {
              value.setFilterSelected(widget.filter.id, v!);
            },
          );
        },
      ),
      title: Text(widget.filter.name),
      subtitle: FilterSummary(filter: widget.filter.configuration),
      onTap: () => widget.onTap(),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

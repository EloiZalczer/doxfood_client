import 'package:doxfood/api.dart';
import 'package:doxfood/widgets/filter_summary.dart';
import 'package:flutter/material.dart';

class FilterTile extends StatelessWidget {
  final Filter filter;
  final Function onTap;

  const FilterTile({super.key, required this.filter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(filter.name),
      subtitle: FilterSummary(filter: filter),
      onTap: () => onTap(),
      trailing: Icon(Icons.chevron_right),
    );
  }
}

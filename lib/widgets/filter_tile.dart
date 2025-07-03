import 'package:flutter/material.dart';

class FilterTile extends StatelessWidget {
  final Function onTap;

  const FilterTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Filter"),
      subtitle: Text("blabla"),
      onTap: () => onTap(),
      trailing: Icon(Icons.chevron_right),
    );
  }
}

import 'package:doxfood/api.dart';
import 'package:flutter/material.dart';

class ConfirmDeleteFilterDialog extends StatelessWidget {
  final Filter filter;

  const ConfirmDeleteFilterDialog({super.key, required this.filter});

  static Future<bool?> show(BuildContext context, Filter filter) {
    return showDialog(
      context: context,
      builder: (context) {
        return ConfirmDeleteFilterDialog(filter: filter);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete filter"),
      content: Text("Do you really want to delete filter ${filter.name} ?"),
      actions: [
        TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(context)),
        ElevatedButton(child: const Text("Remove"), onPressed: () => Navigator.pop(context, true)),
      ],
    );
  }
}

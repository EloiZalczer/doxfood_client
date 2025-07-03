import 'package:doxfood/api.dart';
import 'package:doxfood/widgets/fields/place_type_field.dart';
import 'package:flutter/material.dart';

class CreateTagDialog extends StatefulWidget {
  final PlaceType placeType;

  const CreateTagDialog({super.key, required this.placeType});

  static void show(BuildContext context, PlaceType placeType) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return CreateTagDialog(placeType: placeType);
      },
    );
  }

  @override
  State<CreateTagDialog> createState() => _CreateTagDialogState();
}

class _CreateTagDialogState extends State<CreateTagDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New tag"),
      content: Form(
        child: Column(
          children: [
            PlaceTypeField(options: [widget.placeType], enabled: false),
            TextFormField(
              controller: _controller,
              decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "Name"),
            ),
          ],
        ),
      ),
    );
  }
}

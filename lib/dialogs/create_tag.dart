import 'package:doxfood/api.dart';
import 'package:doxfood/widgets/fields/place_type_field.dart';
import 'package:flutter/material.dart';

class CreateTagResult {
  final PlaceType placeType;
  final String name;

  CreateTagResult({required this.placeType, required this.name});
}

class CreateTagDialog extends StatefulWidget {
  final PlaceType placeType;

  const CreateTagDialog({super.key, required this.placeType});

  static Future<CreateTagResult?> show(BuildContext context, PlaceType placeType) {
    return showDialog(
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
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, CreateTagResult(placeType: widget.placeType, name: _controller.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New tag"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlaceTypeField(
              options: [widget.placeType],
              enabled: false,
              controller: PlaceTypeController(type: widget.placeType),
            ),
            TextFormField(
              controller: _controller,
              decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "Name"),
              validator: (value) {
                if (value == null || value.isEmpty) return "This field is required";
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(child: Text("Cancel"), onPressed: () => Navigator.pop(context)),
        ElevatedButton(child: Text("Save"), onPressed: () => _submit()),
      ],
    );
  }
}

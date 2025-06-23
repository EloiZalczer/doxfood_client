import 'package:doxfood/api.dart';
import 'package:doxfood/database.dart';
import 'package:doxfood/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddServerDialog extends StatefulWidget {
  const AddServerDialog({super.key});

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AddServerDialog();
      },
    );
  }

  @override
  State<StatefulWidget> createState() => _AddServerDialogState();
}

class _AddServerDialogState extends State<AddServerDialog> {
  final _formKey = GlobalKey<FormState>();

  final _urlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final serversList = context.read<ServersListModel>();

    final pb = await connectWithPassword(
      _urlController.text,
      _usernameController.text,
      _passwordController.text,
    );

    if (pb.authStore.isValid) {
      final server = Server(
        name: _nameController.text,
        uri: _urlController.text,
        token: pb.authStore.token,
      );
      serversList.add(server);
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Connect to server"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _urlController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: "URL",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _usernameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: "Username",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: "Password",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: "Name (Optional)",
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: Text("Connect"),
          onPressed: () {
            _submit();
          },
        ),
      ],
    );
  }
}

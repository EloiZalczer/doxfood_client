import 'package:doxfood/models/servers.dart';
import 'package:doxfood/utils/validators.dart';
import 'package:doxfood/widgets/fields/password_field.dart';
import 'package:flutter/material.dart';

class ConnectionExpiredDialog extends StatefulWidget {
  final Server server;

  const ConnectionExpiredDialog({super.key, required this.server});

  static Future<String?> show(BuildContext context, Server server) {
    return showDialog(
      context: context,
      builder: (context) {
        return ConnectionExpiredDialog(server: server);
      },
    );
  }

  @override
  State<ConnectionExpiredDialog> createState() => _ConnectionExpiredDialogState();
}

class _ConnectionExpiredDialogState extends State<ConnectionExpiredDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _valid = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _passwordController.text);
    }
  }

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(() {
      setState(() {
        _valid = !_passwordController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("This connection has expired"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Please connect again."),
            PasswordField(controller: _passwordController, validator: validateRequired),
          ],
        ),
      ),
      actions: [
        TextButton(child: Text("Cancel"), onPressed: () => Navigator.pop(context)),
        ElevatedButton(onPressed: _valid ? null : _submit, child: Text("Connect")),
      ],
    );
  }
}

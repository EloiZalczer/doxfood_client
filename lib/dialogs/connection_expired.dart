import 'package:doxfood/api.dart';
import 'package:doxfood/http_errors.dart';
import 'package:doxfood/models/servers.dart';
import 'package:doxfood/utils/validators.dart';
import 'package:doxfood/widgets/fields/password_field.dart';
import 'package:flutter/material.dart';

class ConnectionExpiredDialog extends StatefulWidget {
  final Server server;

  const ConnectionExpiredDialog({super.key, required this.server});

  static Future<API?> show(BuildContext context, Server server) {
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
  String? _errorMessage;
  bool _valid = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    API api;

    try {
      api = await API.connectWithPassword(widget.server.uri, widget.server.username, _passwordController.text);
    } on BadRequest {
      setState(() {
        _errorMessage = "Invalid password";
      });
      return;
    }

    if (mounted) Navigator.pop(context, api);
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
      title: const Text("This connection has expired"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Please connect again."),
            PasswordField(controller: _passwordController, validator: validateRequired),
            if (_errorMessage != null) Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
      actions: [
        TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(context)),
        ElevatedButton(onPressed: _valid ? null : _submit, child: const Text("Connect")),
      ],
    );
  }
}

import 'package:doxfood/models/servers.dart';
import 'package:doxfood/utils/validators.dart';
import 'package:doxfood/widgets/fields/password_field.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';

class EditServerPage extends StatefulWidget {
  final Server server;

  const EditServerPage({super.key, required this.server});

  @override
  State<StatefulWidget> createState() => _EditServerPageState();
}

class _EditServerPageState extends State<EditServerPage> {
  final _formKey = GlobalKey<FormState>();

  late final _urlController = TextEditingController(text: widget.server.uri);
  late final _nameController = TextEditingController(text: widget.server.name);
  late final _usernameController = TextEditingController();
  late final _passwordController = TextEditingController();

  String? _error;

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _focusNode.dispose();

    super.dispose();
  }

  void _onSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final serversList = context.read<ServersListModel>();

    final pb = PocketBase(_urlController.text);

    try {
      await pb.collection("users").authWithPassword(_usernameController.text, _passwordController.text);
    } on ClientException catch (e) {
      if (e.statusCode == 400) {
        setState(() {
          _error = "Invalid username or password";
        });
      }
      return;
    }

    if (pb.authStore.isValid) {
      await serversList.update(
        widget.server.id,
        _nameController.text,
        _urlController.text,
        _usernameController.text,
        pb.authStore.token,
      );
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Server")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _urlController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "URL"),
                  validator: validateRequired,
                ),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "Name"),
                  validator: validateRequired,
                ),
                TextFormField(
                  focusNode: _focusNode,
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "Username"),
                  validator: validateRequired,
                ),
                PasswordField(controller: _passwordController, validator: validateRequired),
                Spacer(),
                if (_error != null) Text(_error!, style: TextStyle(color: Colors.red)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [ElevatedButton(onPressed: _onSave, child: Text("Save"))],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

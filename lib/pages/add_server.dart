import 'package:doxfood/models/servers.dart';
import 'package:doxfood/widgets/fields/password_field.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';

enum _LoginMode { login, register }

class AddServerPage extends StatefulWidget {
  const AddServerPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddServerPageState();
}

class _AddServerPageState extends State<AddServerPage> {
  final _formKey = GlobalKey<FormState>();

  final _urlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  _LoginMode? _mode;
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

  void _onLoginClicked() async {
    if (_mode == null) {
      setState(() {
        _mode = _LoginMode.login;
      });
      _focusNode.requestFocus();
      return;
    }

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
      final server = Server(name: _nameController.text, uri: _urlController.text, token: pb.authStore.token);
      await serversList.add(server);
    }

    if (mounted) Navigator.of(context).pop();
  }

  void _onRegisterClicked() async {
    if (_mode == null) {
      setState(() {
        _mode = _LoginMode.register;
      });
      _focusNode.requestFocus();
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final serversList = context.read<ServersListModel>();

    final pb = PocketBase(_urlController.text);

    await pb
        .collection("users")
        .create(
          body: {
            "username": _usernameController.text,
            "password": _passwordController.text,
            "passwordConfirm": _confirmPasswordController.text,
          },
        );

    try {
      await pb.collection("users").authWithPassword(_usernameController.text, _passwordController.text);
    } on ClientException catch (e) {
      if (e.statusCode == 400) {
        setState(() {
          _error = "Count not create account";
        });
      }
    }

    if (pb.authStore.isValid) {
      final server = Server(name: _nameController.text, uri: _urlController.text, token: pb.authStore.token);
      await serversList.add(server);
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Server")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            canPop: _mode == null,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                return;
              }

              setState(() {
                _mode = null;
              });
            },
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Row(
                    spacing: 8.0,
                    children: [
                      Expanded(child: LinearProgressIndicator(value: 1.0, borderRadius: BorderRadius.circular(2.0))),
                      Expanded(
                        child: TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          tween: Tween<double>(begin: 0, end: (_mode == null) ? 0 : 1.0),
                          builder:
                              (context, value, _) =>
                                  LinearProgressIndicator(value: value, borderRadius: BorderRadius.circular(2.0)),
                        ),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _urlController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "URL"),
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
                  decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "Name (Optional)"),
                ),
                if (_mode != null) ...[
                  TextFormField(
                    focusNode: _focusNode,
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "Username"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),

                  PasswordField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                ],
                if (_mode == _LoginMode.register) ...[
                  TextFormField(
                    controller: _confirmPasswordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "Confirm password"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                ],
                Spacer(),
                if (_error != null) Text(_error!, style: TextStyle(color: Colors.red)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_mode == null || _mode == _LoginMode.login)
                      ElevatedButton(onPressed: _onLoginClicked, child: Text("Login")),
                    if (_mode == null || _mode == _LoginMode.register)
                      ElevatedButton(onPressed: _onRegisterClicked, child: Text("Register")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

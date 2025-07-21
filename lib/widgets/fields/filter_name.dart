import 'package:flutter/material.dart';

class FilterNameField extends StatefulWidget {
  final TextEditingController? controller;

  const FilterNameField({super.key, this.controller});

  @override
  State<FilterNameField> createState() => _FilterNameFieldState();
}

class _FilterNameFieldState extends State<FilterNameField> {
  late TextEditingController _controller;

  late FocusNode _focusNode;

  bool _editing = false;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _controller = TextEditingController();
    } else {
      _controller = widget.controller!;
    }

    _focusNode = FocusNode();

    if (_controller.text.isEmpty) _startEditing();
  }

  void _startEditing() {
    setState(() {
      _editing = true;
    });

    _focusNode.requestFocus();
  }

  void _stopEditing() {
    setState(() {
      _editing = false;
    });

    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      readOnly: !_editing,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        border: InputBorder.none,
        suffixIcon:
            _editing
                ? IconButton(onPressed: _stopEditing, icon: Icon(Icons.check))
                : IconButton(onPressed: _startEditing, icon: Icon(Icons.edit)),
      ),
    );
  }
}

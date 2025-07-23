import 'package:doxfood/widgets/filter_editor.dart';
import 'package:flutter/material.dart';

class EditQuickFilterPage extends StatefulWidget {
  final FilterConfiguration? configuration;

  const EditQuickFilterPage({super.key, this.configuration});

  @override
  State<EditQuickFilterPage> createState() => _EditQuickFilterPageState();
}

class _EditQuickFilterPageState extends State<EditQuickFilterPage> {
  final GlobalKey<FilterEditorState> _editorKey = GlobalKey<FilterEditorState>();

  void _submit() async {
    if (!_editorKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(_editorKey.currentState!.data());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(),
        body: Center(child: FilterEditor(filter: widget.configuration, key: _editorKey)),
        bottomNavigationBar: ElevatedButton(onPressed: _submit, child: const Text("Save")),
      ),
    );
  }
}

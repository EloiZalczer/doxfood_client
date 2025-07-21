import 'package:doxfood/api.dart';
import 'package:doxfood/dialogs/confirm_delete_filter.dart';
import 'package:doxfood/models/filters.dart';
import 'package:doxfood/widgets/fields/filter_name.dart';
import 'package:doxfood/widgets/filter_editor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditFilterPage extends StatefulWidget {
  final Filter? filter;

  const EditFilterPage({super.key, this.filter});

  @override
  State<EditFilterPage> createState() => _EditFilterPageState();
}

class _EditFilterPageState extends State<EditFilterPage> {
  final GlobalKey<FilterEditorState> _editorKey = GlobalKey<FilterEditorState>();

  late TextEditingController _filterNameController;

  void _onDelete(BuildContext context) async {
    if (widget.filter == null) return;

    final result = await ConfirmDeleteFilterDialog.show(context, widget.filter!);

    if (result == true && context.mounted) {
      context.read<FiltersModel>().delete(widget.filter!.id);
      Navigator.of(context).pop();
    }
  }

  void _submit() async {
    if (!_editorKey.currentState!.validate()) {
      return;
    }

    final configuration = _editorKey.currentState!.data();

    await context.read<FiltersModel>().save(
      (widget.filter != null) ? widget.filter!.id : null,
      _filterNameController.text,
      configuration,
    );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    final String? filterName = (widget.filter == null) ? null : widget.filter!.name;
    _filterNameController = TextEditingController(text: filterName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: FilterNameField(controller: _filterNameController),
          actions: [
            if (widget.filter != null) IconButton(onPressed: () => _onDelete(context), icon: Icon(Icons.delete)),
          ],
        ),
        body: Center(child: FilterEditor(filter: widget.filter?.configuration)),
        bottomNavigationBar: ElevatedButton(onPressed: _submit, child: Text("Save")),
      ),
    );
  }
}

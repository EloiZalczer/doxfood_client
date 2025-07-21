import 'package:doxfood/pages/edit_filter.dart';
import 'package:doxfood/pages/edit_quick_filter.dart';
import 'package:doxfood/pages/filters_list.dart';
import 'package:doxfood/widgets/filter_editor.dart';
import 'package:doxfood/widgets/filter_summary.dart';
import 'package:doxfood/widgets/selectable_container.dart';
import 'package:flutter/material.dart';

class SavedFiltersContainer extends StatefulWidget {
  final SelectionController controller;

  const SavedFiltersContainer({super.key, required this.controller});

  @override
  State<SavedFiltersContainer> createState() => _SavedFiltersContainerState();
}

class _SavedFiltersContainerState extends State<SavedFiltersContainer> {
  final String value = "saved_filters";

  FilterConfiguration? configuration;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      setState(() {});
    });
  }

  void _onConfigure() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => FiltersListPage()));

    if (result != null) {
      setState(() {
        configuration = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SelectableContainer(
      title: "Saved filters",
      controller: widget.controller,
      value: value,
      height: 130,
      child: Center(
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: (widget.controller.selected == value) ? _onConfigure : null,
              label: Text("Configure"),
              icon: Icon(Icons.settings),
            ),
            if (configuration != null) Center(child: FilterSummary(filter: configuration!)),
          ],
        ),
      ),
    );
  }
}

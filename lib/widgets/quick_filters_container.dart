import 'package:doxfood/pages/edit_quick_filter.dart';
import 'package:doxfood/widgets/filter_editor.dart';
import 'package:doxfood/widgets/filter_summary.dart';
import 'package:doxfood/widgets/selectable_container.dart';
import 'package:flutter/material.dart';

class QuickFiltersContainer extends StatefulWidget {
  final SelectionController controller;

  const QuickFiltersContainer({super.key, required this.controller});

  @override
  State<QuickFiltersContainer> createState() => _QuickFiltersContainerState();
}

class _QuickFiltersContainerState extends State<QuickFiltersContainer> {
  final String value = "quick_filter";

  FilterConfiguration? configuration;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      setState(() {});
    });
  }

  void _onConfigure() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditQuickFilterPage(configuration: configuration)),
    );

    if (result != null) {
      setState(() {
        configuration = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SelectableContainer(
      title: "Quick filters",
      controller: widget.controller,
      value: value,
      height: 130,
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
    );
  }
}

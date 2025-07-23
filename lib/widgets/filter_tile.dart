import 'package:doxfood/api.dart';
import 'package:doxfood/controllers/multiple_selection_controller.dart';
import 'package:doxfood/widgets/filter_summary.dart';
import 'package:flutter/material.dart';

class FilterTile extends StatefulWidget {
  final MultipleSelectionController controller;
  final Filter filter;
  final Function onTap;

  const FilterTile({super.key, required this.filter, required this.onTap, required this.controller});

  @override
  State<FilterTile> createState() => _FilterTileState();
}

class _FilterTileState extends State<FilterTile> {
  late bool selected;

  @override
  void initState() {
    super.initState();
    selected = widget.controller.isSelected(widget.filter.id);
    widget.controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    final state = widget.controller.isSelected(widget.filter.id);

    if (state != selected) {
      setState(() {
        selected = state;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: widget.controller.isSelected(widget.filter.id),
        onChanged: (v) {
          widget.controller.setSelected(widget.filter.id, v!);
        },
      ),
      title: Text(widget.filter.name),
      subtitle: FilterSummary(filter: widget.filter.configuration),
      onTap: () => widget.onTap(),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

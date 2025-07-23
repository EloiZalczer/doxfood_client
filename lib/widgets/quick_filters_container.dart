import 'package:doxfood/models/random_config.dart';
import 'package:doxfood/pages/edit_quick_filter.dart';
import 'package:doxfood/widgets/filter_editor.dart';
import 'package:doxfood/widgets/filter_summary.dart';
import 'package:doxfood/widgets/selectable_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuickFiltersContainer extends StatefulWidget {
  final bool? selected;
  final VoidCallback? onTap;

  const QuickFiltersContainer({super.key, this.selected, this.onTap});

  @override
  State<QuickFiltersContainer> createState() => _QuickFiltersContainerState();
}

class _QuickFiltersContainerState extends State<QuickFiltersContainer> {
  void _onConfigure() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditQuickFilterPage(configuration: context.read<RandomConfigurationModel>().quickFilter),
      ),
    );

    if (mounted && result != null) {
      context.read<RandomConfigurationModel>().quickFilter = result;
    }
  }

  @override
  Widget build(BuildContext context) {
    final quickFilter = context.read<RandomConfigurationModel>().quickFilter;

    return SelectableContainer(
      title: "Quick filters",
      selected: widget.selected,
      onTap: widget.onTap,
      height: 110,
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: (widget.selected ?? false) ? _onConfigure : null,
            label: (quickFilter == null) ? const Text("Configure") : FilterSummary(filter: quickFilter),
            icon: const Icon(Icons.settings),
          ),
          // if (quickFilter != null) Center(child: FilterSummary(filter: quickFilter)),
        ],
      ),
    );
  }
}

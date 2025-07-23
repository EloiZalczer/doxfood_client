import 'package:doxfood/models/filters.dart';
import 'package:doxfood/models/random_config.dart';
import 'package:doxfood/pages/filters_list.dart';
import 'package:doxfood/widgets/selectable_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedFiltersContainer extends StatefulWidget {
  final bool? selected;
  final VoidCallback? onTap;

  const SavedFiltersContainer({super.key, this.selected, this.onTap});

  @override
  State<SavedFiltersContainer> createState() => _SavedFiltersContainerState();
}

class _SavedFiltersContainerState extends State<SavedFiltersContainer> {
  void _onConfigure() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const FiltersListPage()));
  }

  @override
  Widget build(BuildContext context) {
    final selectedFilters = context.read<RandomConfigurationModel>().selectedFilters;

    return SelectableContainer(
      title: "Saved filters",
      selected: widget.selected,
      onTap: widget.onTap,
      height: 120,
      child: Center(
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: (widget.selected ?? false) ? _onConfigure : null,
              label: const Text("Configure"),
              icon: const Icon(Icons.settings),
            ),
            if (selectedFilters.isNotEmpty)
              Center(
                child: Text(
                  selectedFilters.map((element) => context.read<FiltersModel>().getById(element).name).join(", "),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

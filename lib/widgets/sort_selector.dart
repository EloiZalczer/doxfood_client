import 'package:doxfood/api.dart';
import 'package:flutter/material.dart';

class SortSelector extends StatefulWidget {
  final SortController? controller;

  const SortSelector({super.key, this.controller});

  @override
  State<SortSelector> createState() => _SortSelectorState();
}

class _SortSelectorState extends State<SortSelector> {
  late SortController controller;

  @override
  void initState() {
    super.initState();

    controller = widget.controller ?? SortController("created", SortOrder.descending);

    controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InputChip(
          avatar:
              (controller.sortedBy == "created")
                  ? (controller.sortOrder == SortOrder.descending)
                      ? const Icon(Icons.keyboard_arrow_down)
                      : const Icon(Icons.keyboard_arrow_up)
                  : null,
          label: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.35,
            child: const Text("Creation date", textAlign: TextAlign.center),
          ),
          onPressed: () {
            setState(() {
              controller.sortedBy = "created";
              controller.sortOrder =
                  (controller.sortedBy == "rating")
                      ? SortOrder.descending
                      : (controller.sortOrder == SortOrder.ascending)
                      ? SortOrder.descending
                      : SortOrder.ascending;
            });
          },
        ),
        InputChip(
          avatar:
              (controller.sortedBy == "rating")
                  ? (controller.sortOrder == SortOrder.descending)
                      ? const Icon(Icons.keyboard_arrow_down)
                      : const Icon(Icons.keyboard_arrow_up)
                  : null,
          label: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.35,
            child: const Text("Rating", textAlign: TextAlign.center),
          ),
          onPressed: () {
            setState(() {
              controller.sortedBy = "rating";
              controller.sortOrder =
                  (controller.sortedBy == "created")
                      ? SortOrder.descending
                      : (controller.sortOrder == SortOrder.ascending)
                      ? SortOrder.descending
                      : SortOrder.ascending;
            });
          },
        ),
      ],
    );
  }
}

class SortController extends ChangeNotifier {
  String _sortedBy;
  SortOrder _sortOrder;

  SortController(String sortedBy, SortOrder sortOrder) : _sortedBy = sortedBy, _sortOrder = sortOrder;

  String get sortedBy => _sortedBy;
  SortOrder get sortOrder => _sortOrder;

  set sortedBy(String value) {
    _sortedBy = value;
    notifyListeners();
  }

  set sortOrder(SortOrder value) {
    _sortOrder = value;
    notifyListeners();
  }
}

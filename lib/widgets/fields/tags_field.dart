import 'dart:collection';

import 'package:doxfood/api.dart';
import 'package:doxfood/utils/color.dart';
import 'package:flutter/material.dart';

class TagsField extends StatefulWidget {
  final TagsController? controller;
  final List<Tag> options;
  final VoidCallback? onCreateTag;
  final bool enabled;

  const TagsField({
    super.key,
    required this.options,
    this.controller,
    bool autovalidate = false,
    this.onCreateTag,
    this.enabled = true,
  });

  @override
  State<TagsField> createState() => _TagsFieldState();
}

class _TagsFieldState extends State<TagsField> {
  late TagsController controller = widget.controller ?? TagsController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              children:
                  widget.options
                      .map(
                        (opt) => TagItem(name: opt.name, id: opt.id, controller: controller, enabled: widget.enabled),
                      )
                      .toList(),
            ),
          ),
        ),
        TextButton(onPressed: widget.enabled ? widget.onCreateTag : null, child: Text("Nouveau tag")),
      ],
    );
  }
}

class TagItem extends StatelessWidget {
  final String name;
  final String id;
  final TagsController controller;
  final bool enabled;

  const TagItem({super.key, required this.name, required this.id, required this.controller, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? () => controller.toggle(id) : null,
      child: Chip(
        label: Text(name, style: TextStyle(color: controller.isSelected(id) ? Colors.black : Colors.grey)),
        backgroundColor: controller.isSelected(id) ? colorFromText(name) : Colors.white,
        side: BorderSide(color: colorFromText(name)),
      ),
    );
  }
}

class TagsController extends ChangeNotifier {
  final Set<String> _selected = {};

  TagsController({Iterable<String>? selected}) {
    if (selected != null) _selected.addAll(selected);
  }

  Set<String> get selected => UnmodifiableSetView(_selected);

  bool isSelected(String id) {
    return _selected.contains(id);
  }

  void select(String id) {
    _selected.add(id);
    notifyListeners();
  }

  void deselect(String id) {
    _selected.remove(id);
    notifyListeners();
  }

  void toggle(String id) {
    if (_selected.contains(id)) {
      _selected.remove(id);
    } else {
      _selected.add(id);
    }
    notifyListeners();
  }
}

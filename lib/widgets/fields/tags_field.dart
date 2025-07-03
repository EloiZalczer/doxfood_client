import 'dart:collection';

import 'package:doxfood/api.dart';
import 'package:doxfood/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class TagsField extends FormField<List<String>> {
  TagsField({
    super.key,
    super.onSaved,
    super.validator,
    List<String> super.initialValue = const [],
    required List<Tag> options,
    MultiSelectController<Tag>? controller,
    bool autovalidate = false,
  }) : super(
         builder: (FormFieldState<List<String>> state) {
           return MultiDropdown(
             controller: controller,
             searchEnabled: true,
             items: options.map((opt) => DropdownItem(label: opt.name, value: opt.id)).toList(),
             fieldDecoration: FieldDecoration(labelText: "Tags", border: UnderlineInputBorder()),
           );
         },
       );
}

// class OtherTagsField extends FormField<List<String>> {
//   OtherTagsField({
//     super.key,
//     super.onSaved,
//     super.validator,
//     List<String> super.initialValue = const [],
//     required List<Tag> options,
//     TagsController? controller,
//     bool autovalidate = false,
//   }) : super(
//          builder: (FormFieldState<List<String>> state) {
//            return Wrap(children: options.map((opt) => TagItem(name: opt.name, id: opt.id)).toList());
//          },
//        );
// }

class OtherTagsField extends StatefulWidget {
  final TagsController? controller;
  final List<Tag> options;

  const OtherTagsField({super.key, required this.options, this.controller, bool autovalidate = false});

  @override
  State<OtherTagsField> createState() => _OtherTagsFieldState();
}

class _OtherTagsFieldState extends State<OtherTagsField> {
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
        Wrap(
          spacing: 10,
          children: widget.options.map((opt) => TagItem(name: opt.name, id: opt.id, controller: controller)).toList(),
        ),
        TextButton(onPressed: () {}, child: Text("Nouveau tag")),
      ],
    );
  }
}

class TagItem extends StatelessWidget {
  final String name;
  final String id;
  final TagsController controller;

  const TagItem({super.key, required this.name, required this.id, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Chip(
        label: Text(name, style: TextStyle(color: controller.isSelected(id) ? Colors.black : Colors.grey)),
        // avatar: controller.isSelected(id) ? CircleAvatar(child: Icon(Icons.check)) : null,
        backgroundColor: controller.isSelected(id) ? colorFromText(name) : Colors.white,
        side: BorderSide(color: colorFromText(name)),
      ),
      onTap: () => controller.toggle(id),
    );
  }
}

class TagsController extends ChangeNotifier {
  final Set<String> _selected = Set();

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

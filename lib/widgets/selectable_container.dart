import 'package:flutter/material.dart';

class SelectableContainer extends StatefulWidget {
  final String value;
  final Widget child;
  final String? title;
  final SelectionController? controller;

  final double? width;
  final double? height;

  const SelectableContainer({
    super.key,
    required this.value,
    required this.child,
    this.controller,
    this.title,
    this.width,
    this.height,
  });

  @override
  State<SelectableContainer> createState() => _SelectableContainerState();
}

class _SelectableContainerState extends State<SelectableContainer> {
  late SelectionController controller = widget.controller ?? SelectionController(selected: widget.value);

  @override
  void initState() {
    super.initState();

    controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    controller.removeListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    setState(() {});
  }

  Color? _titleColor() {
    if (controller.selected == widget.value) {
      return Colors.blue[700];
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = _titleColor();

    return Material(
      color:
          (controller.selected == widget.value) ? Theme.of(context).primaryColorLight : Theme.of(context).canvasColor,
      child: InkWell(
        onTap: () {
          if (controller.selected != widget.value) controller.selected = widget.value;
        },
        child: SizedBox(
          height: widget.height,
          width: widget.width,
          child:
              (widget.title == null)
                  ? widget.child
                  : ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.title!, style: TextStyle(fontWeight: FontWeight.w500, color: titleColor)),
                        (controller.selected == widget.value)
                            ? Icon(Icons.check_circle, color: titleColor)
                            : Icon(Icons.circle_outlined, color: titleColor),
                      ],
                    ),
                    subtitle: widget.child,
                  ),
        ),
      ),
    );
  }
}

class SelectionController extends ChangeNotifier {
  String? _selected;

  SelectionController({selected}) : _selected = selected;

  String? get selected => _selected;

  set selected(String? value) {
    _selected = value;
    notifyListeners();
  }
}

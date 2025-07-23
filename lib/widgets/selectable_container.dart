import 'package:flutter/material.dart';

class SelectableContainer extends StatefulWidget {
  final Widget child;
  final String? title;
  final bool? selected;
  final VoidCallback? onTap;

  final double? width;
  final double? height;

  const SelectableContainer({
    super.key,
    required this.child,
    this.selected,
    this.onTap,
    this.title,
    this.width,
    this.height,
  });

  @override
  State<SelectableContainer> createState() => _SelectableContainerState();
}

class _SelectableContainerState extends State<SelectableContainer> {
  Color? _titleColor() {
    if (widget.selected ?? false) {
      return Colors.blue[700];
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = _titleColor();

    return Material(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: titleColor ?? Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      color: (widget.selected ?? false) ? Theme.of(context).primaryColorLight : Theme.of(context).canvasColor,
      child: InkWell(
        onTap: widget.onTap,
        child: Stack(
          children: [
            SizedBox(
              height: widget.height,
              width: widget.width,
              child:
                  (widget.title == null)
                      ? widget.child
                      : ListTile(
                        title: Text(widget.title!, style: TextStyle(fontWeight: FontWeight.w500, color: titleColor)),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(widget.title!, style: TextStyle(fontWeight: FontWeight.w500, color: titleColor)),
                        //     (widget.selected ?? false)
                        //         ? Icon(Icons.check_circle, color: titleColor)
                        //         : Icon(Icons.circle_outlined, color: titleColor),
                        //   ],
                        // ),
                        subtitle: Padding(padding: const EdgeInsets.only(top: 8.0), child: widget.child),
                      ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child:
                  (widget.selected ?? false)
                      ? Icon(Icons.check_circle, color: titleColor)
                      : Icon(Icons.circle_outlined, color: titleColor),
            ),
          ],
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

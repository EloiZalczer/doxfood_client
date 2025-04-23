import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final ExpansionTileController expansionTileController;

  const SearchWidget({super.key, required this.expansionTileController});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  Color tileColor = Colors.transparent;
  double textFieldPadding = 10.0;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: tileColor,
      controller: widget.expansionTileController,
      showTrailingIcon: false,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(50)),
      title: SizedBox(
        height: 40,
        child: Padding(
          padding: EdgeInsets.only(
            left: textFieldPadding,
            right: textFieldPadding,
          ),
          child: Center(
            child: TextField(
              textInputAction: TextInputAction.search,
              onEditingComplete: () {
                widget.expansionTileController.collapse();
                FocusScope.of(context).unfocus();
              },
              onTap: () {
                widget.expansionTileController.expand();
                setState(() {
                  tileColor = Colors.white;
                });
              },
              style: TextStyle(height: 0.6),
              cursorHeight: 20,
              // showCursor: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.tune),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(width: 1),
                ),
              ),
            ),
          ),
        ),
      ),
      children: [Placeholder(fallbackHeight: 100)],
    );
  }
}

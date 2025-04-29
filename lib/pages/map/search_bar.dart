import 'package:doxfood/pages/map/search_panel.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Color tileColor = Colors.transparent;
  double textFieldPadding = 10.0;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: EdgeInsets.only(
          left: textFieldPadding,
          right: textFieldPadding,
        ),
        child: Center(
          child: TextField(
            controller: controller,
            readOnly: true,
            textInputAction: TextInputAction.search,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPanel(controller: controller),
                ),
              );
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
    );
  }
}

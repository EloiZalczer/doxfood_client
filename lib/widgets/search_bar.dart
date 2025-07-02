import 'package:doxfood/models/places.dart';
import 'package:doxfood/widgets/search_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Color tileColor = Colors.transparent;
  double textFieldPadding = 10.0;
  double borderRadius = 18.0;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: EdgeInsets.only(left: textFieldPadding, right: textFieldPadding),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(spreadRadius: 0.0, blurRadius: 2.0)],
            borderRadius: BorderRadius.circular(borderRadius),
            // shape: BoxShape.circle,
          ),
          child: TextField(
            controller: controller,
            readOnly: true,
            textInputAction: TextInputAction.search,
            onTap: () {
              final model = context.read<PlacesModel>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ChangeNotifierProvider<PlacesModel>.value(
                        value: model,
                        child: SearchPanel(controller: controller),
                      ),
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
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(width: 0, style: BorderStyle.none),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

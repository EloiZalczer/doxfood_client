import 'package:doxfood/api.dart';
import 'package:doxfood/widgets/search_panel.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final Function(PlaceInfo place)? onPlaceSelected;

  const SearchField({super.key, this.onPlaceSelected});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Color tileColor = Colors.transparent;
  double textFieldPadding = 10.0;
  double borderRadius = 18.0;
  TextEditingController controller = TextEditingController();

  void _onSearch() async {
    final result = await Navigator.push<PlaceInfo?>(
      context,
      MaterialPageRoute(builder: (context) => SearchPanel(controller: controller)),
    );

    if (result != null && widget.onPlaceSelected != null) {
      widget.onPlaceSelected!(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: EdgeInsets.only(left: textFieldPadding, right: textFieldPadding),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [BoxShadow(spreadRadius: 0.0, blurRadius: 2.0)],
            borderRadius: BorderRadius.circular(borderRadius),
            // shape: BoxShape.circle,
          ),
          child: TextField(
            controller: controller,
            readOnly: true,
            textInputAction: TextInputAction.search,
            onTap: _onSearch,
            style: const TextStyle(height: 0.6),
            cursorHeight: 20,
            // showCursor: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.tune),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(width: 0, style: BorderStyle.none),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

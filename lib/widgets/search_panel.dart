import 'package:doxfood/api.dart';
import 'package:doxfood/models/places.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPanel extends StatefulWidget {
  const SearchPanel({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {
  List<PlaceInfo> suggestions = [];

  void _updateSuggestions() {
    if (widget.controller.text.isEmpty) {
      setState(() {
        suggestions = [];
      });
    } else {
      setState(() {
        suggestions =
            context
                .read<PlacesModel>()
                .places
                .where((PlaceInfo p) => p.name.toLowerCase().startsWith(widget.controller.text.toLowerCase()))
                .take(10)
                .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateSuggestions);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_updateSuggestions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 40,
            child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Center(
                child: TextField(
                  controller: widget.controller,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(height: 0.6),
                  cursorHeight: 20,
                  // showCursor: false,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (suggestions.isNotEmpty)
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(suggestions[index].name));
                },
              ),
            ),
        ],
      ),
    );
  }
}

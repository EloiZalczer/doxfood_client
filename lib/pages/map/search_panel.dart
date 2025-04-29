import 'package:flutter/material.dart';

class SearchPanel extends StatefulWidget {
  const SearchPanel({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {
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

          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Search"),
            ),
          ),
        ],
      ),
    );
  }
}

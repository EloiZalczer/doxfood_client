import 'package:flutter/material.dart';

class PriceField extends StatefulWidget {
  const PriceField({super.key});

  @override
  State<PriceField> createState() => _PriceFieldState();
}

class _PriceFieldState extends State<PriceField> {
  int? _selectedIndex;
  List<String> labels = ["1-10€", "10-15€", "15-20€", ">20€"];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (int index) {
        return InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap:
              () => setState(() {
                _selectedIndex = index;
              }),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: (index == _selectedIndex) ? Colors.blue : Colors.white,
            ),
            child: Text(labels[index], style: TextStyle(color: index == _selectedIndex ? Colors.white : Colors.black)),
          ),
        );
      }),
    );
  }
}

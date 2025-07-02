import 'package:flutter/material.dart';

class PriceField extends StatefulWidget {
  final PriceController? controller;

  const PriceField({super.key, this.controller});

  @override
  State<PriceField> createState() => _PriceFieldState();
}

class _PriceFieldState extends State<PriceField> {
  List<String> labels = ["1-10€", "10-15€", "15-20€", ">20€"];

  late PriceController controller;

  @override
  void initState() {
    super.initState();

    controller = widget.controller ?? PriceController();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (int index) {
        return InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () => controller.price = index,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: (index == controller.price) ? Colors.blue : Colors.white,
            ),
            child: Text(
              labels[index],
              style: TextStyle(color: index == controller.price ? Colors.white : Colors.black),
            ),
          ),
        );
      }),
    );
  }
}

class PriceController extends ChangeNotifier {
  int? _price;

  PriceController({int? price}) : _price = price;

  set price(int? value) {
    _price = value;
    notifyListeners();
  }

  int? get price => _price;
}

import 'package:flutter/material.dart';

String priceToLabel(int price) {
  return "€" * price;
}

int labelToPrice(String label) {
  return {"€": 1, "€€": 2, "€€€": 3, "€€€€": 4}[label]!;
}

class PriceRangeField extends StatefulWidget {
  final PriceRangeController? controller;
  final bool enabled;

  const PriceRangeField({super.key, this.controller, this.enabled = true});

  @override
  State<PriceRangeField> createState() => _PriceRangeFieldState();
}

class _PriceRangeFieldState extends State<PriceRangeField> {
  late final PriceRangeController _controller = widget.controller ?? PriceRangeController(min: 1, max: 4);

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      min: 1,
      max: 4,
      values: RangeValues(_controller.min.toDouble(), _controller.max.toDouble()),
      labels: RangeLabels(priceToLabel(_controller.min), priceToLabel(_controller.max)),
      divisions: 3,
      onChanged:
          widget.enabled
              ? (RangeValues values) {
                if (values.start == values.end) return;
                _controller.setRange(values.start.toInt(), values.end.toInt());
              }
              : null,
    );
  }
}

class PriceRangeController extends ChangeNotifier {
  int _min;
  int _max;

  PriceRangeController({required int min, required int max}) : _min = min, _max = max;

  int get min => _min;

  set min(int min) {
    _min = min;
    notifyListeners();
  }

  int get max => _max;

  set max(int max) {
    _max = max;
    notifyListeners();
  }

  void setRange(int min, int max) {
    _min = min;
    _max = max;
    notifyListeners();
  }
}

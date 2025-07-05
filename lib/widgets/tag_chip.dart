import 'package:doxfood/api.dart';
import 'package:doxfood/utils/color.dart';
import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final Tag tag;

  const TagChip({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: colorFromText(tag.name),
      label: Text(tag.name),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity(horizontal: 0.0, vertical: -4),
    );
  }
}

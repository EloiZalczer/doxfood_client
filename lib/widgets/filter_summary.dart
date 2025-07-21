import 'package:doxfood/widgets/filter_editor.dart';
import 'package:flutter/material.dart';

extension Intersperse<T> on Iterable<T> {
  Iterable<T> intersperse(T separator) sync* {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      yield iterator.current;
      while (iterator.moveNext()) {
        yield separator;
        yield iterator.current;
      }
    }
  }
}

class FilterSummary extends StatelessWidget {
  final FilterConfiguration filter;

  const FilterSummary({super.key, required this.filter});

  Widget _buildPriceRange() {
    return Text("${filter.lowerPriceBound}-${filter.upperPriceBound}");
  }

  Widget _buildIncludedTags() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Text(filter.includedTags.length.toString()), Icon(Icons.label)],
    );
  }

  Widget _buildExcludedTags() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Text(filter.excludedTags.length.toString()), Icon(Icons.label_off)],
    );
  }

  Widget _buildIncludedPlaces() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Text(filter.includedPlaces.length.toString()), Icon(Icons.location_on)],
    );
  }

  Widget _buildExcludedPlaces() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Text(filter.excludedPlaces.length.toString()), Icon(Icons.location_off)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4.0,
      mainAxisSize: MainAxisSize.min,
      children:
          [
            if (filter.priceRangeEnabled) _buildPriceRange(),
            if (filter.includeTagsEnabled) _buildIncludedTags(),
            if (filter.excludeTagsEnabled) _buildExcludedTags(),
            if (filter.includePlacesEnabled) _buildIncludedPlaces(),
            if (filter.excludePlacesEnabled) _buildExcludedPlaces(),
          ].intersperse(Text("•", style: TextStyle(color: Theme.of(context).hintColor))).toList(),
    );
  }
}

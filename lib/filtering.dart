import 'package:doxfood/api.dart';

bool _filterValue(List options, value, bool negative) {
  if (negative) {
    return !options.contains(value);
  } else {
    return options.contains(value);
  }
}

bool filterPlaces(String field, String? subfield, List options, bool negative, Map place) {
  if (place[field] is List) {
    for (var element in place[field]) {
      if (subfield != null) {
        element = element[subfield];
      }

      if (negative) {
        if (!_filterValue(options, element, negative)) {
          return false;
        }
      } else {
        if (_filterValue(options, element, negative)) {
          return true;
        }
      }
    }
    return negative;
  } else {
    return _filterValue(options, place[field], negative);
  }
}

List<bool Function(Map place)> makeFilters(Filter config) {
  List<bool Function(Map place)> filters = [];

  if (config.includeTagsEnabled && config.includedTags.isNotEmpty) {
    filters.add((Map place) => filterPlaces("tags", "id", config.includedTags, false, place));
  }

  if (config.excludeTagsEnabled && config.excludedTags.isNotEmpty) {
    filters.add((Map place) => filterPlaces("tags", "id", config.excludedTags, true, place));
  }

  if (config.includePlacesEnabled && config.includedPlaces.isNotEmpty) {
    filters.add((Map place) => filterPlaces("id", null, config.includedPlaces, false, place));
  }

  if (config.excludePlacesEnabled && config.excludedPlaces.isNotEmpty) {
    filters.add((Map place) => filterPlaces("id", null, config.excludedPlaces, true, place));
  }

  if (config.priceRangeEnabled) {
    final prices = ["€", "€€", "€€€", "€€€€"];

    final lowerIndex = prices.indexOf(config.lowerPriceBound);
    final upperIndex = prices.indexOf(config.upperPriceBound);

    final values = prices.getRange(lowerIndex, upperIndex + 1).toList();

    filters.add((Map place) => filterPlaces("price", null, values, false, place));
  }

  return filters;
}

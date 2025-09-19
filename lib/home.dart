import 'package:doxfood/api.dart';
import 'package:doxfood/models/filtered_places.dart';
import 'package:doxfood/models/filters.dart';
import 'package:doxfood/models/place_types.dart';
import 'package:doxfood/models/places.dart';
import 'package:doxfood/models/random_config.dart';
import 'package:doxfood/models/selection.dart';
import 'package:doxfood/models/servers.dart';
import 'package:doxfood/models/tags.dart';
import 'package:doxfood/pages/map.dart';
import 'package:doxfood/pages/random.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final API api;

  const HomePage({super.key, required this.api});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _navigatorKey = GlobalKey<NavigatorState>();

  late final PlacesModel places;
  late final TagsModel tags;
  late final PlaceTypesModel placeTypes;
  late final FiltersModel filters;
  late final FilteredPlacesModel filtered;

  @override
  void initState() {
    super.initState();

    places = PlacesModel(api: widget.api);
    tags = TagsModel(api: widget.api);
    placeTypes = PlaceTypesModel(api: widget.api);
    filters = FiltersModel(api: widget.api);

    // Load tags, place types and filters before loading places because places
    // require tags and types to be loaded in order to be displayed. Ideally,
    // when we get to a lot of places, the flow should be to load tags, types
    // and filters at the start, then load places dynamically when we need them.
    // For now this is good enough.
    Future.wait([tags.load(), placeTypes.load(), filters.load()]).then((value) => places.load());

    filtered = FilteredPlacesModel(places);

    context.read<RandomConfigurationModel>().load(context.read<ServersModel>().currentServer!);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlacesModel>.value(value: places),
        ChangeNotifierProvider<TagsModel>.value(value: tags),
        ChangeNotifierProvider<PlaceTypesModel>.value(value: placeTypes),
        ChangeNotifierProvider<FiltersModel>.value(value: filters),
        ChangeNotifierProvider<FilteredPlacesModel>.value(value: filtered),
        ChangeNotifierProvider<SelectionModel>(create: (context) => SelectionModel()),
        Provider<API>.value(value: widget.api),
      ],
      child: NavigatorPopHandler(
        onPopWithResult: (result) {
          _navigatorKey.currentState!.maybePop(result);
        },
        child: Navigator(
          key: _navigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) {
                return SafeArea(
                  top: false,
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    body: DefaultTabController(
                      length: 2,
                      child: Builder(
                        builder: (context) {
                          return Scaffold(
                            bottomNavigationBar: TabBar(
                              tabs: const [Tab(icon: Icon(Icons.map)), Tab(icon: Icon(Icons.casino))],
                              isScrollable: false,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                border: Border(top: BorderSide(color: Theme.of(context).hintColor, width: 3.0)),
                              ),
                            ),
                            body: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                const MapPage(),
                                RandomPage(
                                  onSuggestionClicked: (place) {
                                    DefaultTabController.of(context).animateTo(0);
                                    context.read<SelectionModel>().selected = place;
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

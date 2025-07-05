import 'package:doxfood/api.dart';
import 'package:doxfood/models/filters.dart';
import 'package:doxfood/models/place_types.dart';
import 'package:doxfood/models/places.dart';
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
  // final _tabControllerKey = GlobalKey<State<DefaultTabController>>();

  // void onPlaceSuggestionClicked(PlaceInfo place, BuildContext context) {
  //   print("suggestion clicked");

  //   DefaultTabController.of(context).animateTo(0);
  // }

  late void Function(PlaceInfo place) openPlacePanel;

  @override
  Widget build(BuildContext context) {
    final PlacesModel places = PlacesModel(api: widget.api);
    final TagsModel tags = TagsModel(api: widget.api);
    final PlaceTypesModel placeTypes = PlaceTypesModel(api: widget.api);
    final FiltersModel filters = FiltersModel(api: widget.api);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlacesModel>.value(value: places),
        ChangeNotifierProvider<TagsModel>.value(value: tags),
        ChangeNotifierProvider<PlaceTypesModel>.value(value: placeTypes),
        ChangeNotifierProvider<FiltersModel>.value(value: filters),
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
                              tabs: [Tab(icon: Icon(Icons.map)), Tab(icon: Icon(Icons.casino))],
                              isScrollable: false,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                border: Border(top: BorderSide(color: Theme.of(context).hintColor, width: 3.0)),
                              ),
                            ),
                            body: TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                MapPage(
                                  builder: (BuildContext context, void Function(PlaceInfo place) onOpenPlace) {
                                    openPlacePanel = onOpenPlace;
                                  },
                                ),
                                RandomPage(
                                  onSuggestionClicked: (place) {
                                    DefaultTabController.of(context).animateTo(0);
                                    openPlacePanel(place);
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

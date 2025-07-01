import 'package:doxfood/api.dart';
import 'package:doxfood/models/places.dart';
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
  @override
  Widget build(BuildContext context) {
    final PlacesModel places = PlacesModel(api: widget.api);
    final TagsModel tags = TagsModel(api: widget.api);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlacesModel>.value(value: places),
        ChangeNotifierProvider<TagsModel>.value(value: tags),
        Provider<API>.value(value: widget.api),
      ],
      child: SafeArea(
        top: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: DefaultTabController(
            length: 2,
            child: Scaffold(
              bottomNavigationBar: TabBar(
                tabs: [Tab(icon: Icon(Icons.map)), Tab(icon: Icon(Icons.casino))],
                isScrollable: false,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  border: Border(top: BorderSide(color: Theme.of(context).hintColor, width: 3.0)),
                ),
              ),
              body: const TabBarView(physics: NeverScrollableScrollPhysics(), children: [MapPage(), RandomPage()]),
            ),
          ),
        ),
      ),
    );

    // return FutureBuilder(
    //   future: _load(),
    //   builder: (BuildContext context, AsyncSnapshot<_Models> snapshot) {
    //     if (snapshot.hasData) {
    //       return MultiProvider(
    //         providers: [
    //           ChangeNotifierProvider<PlacesModel>.value(value: snapshot.data!.places),
    //           ChangeNotifierProvider<TagsModel>.value(value: snapshot.data!.tags),
    //           Provider<API>.value(value: snapshot.data!.api),
    //         ],
    //         child: SafeArea(
    //           top: false,
    //           child: Scaffold(
    //             resizeToAvoidBottomInset: false,
    //             body: DefaultTabController(
    //               length: 2,
    //               child: Scaffold(
    //                 bottomNavigationBar: TabBar(
    //                   tabs: [Tab(icon: Icon(Icons.map)), Tab(icon: Icon(Icons.casino))],
    //                   isScrollable: false,
    //                   indicatorSize: TabBarIndicatorSize.tab,
    //                   indicator: BoxDecoration(
    //                     border: Border(top: BorderSide(color: Theme.of(context).hintColor, width: 3.0)),
    //                   ),
    //                 ),
    //                 body: const TabBarView(
    //                   physics: NeverScrollableScrollPhysics(),
    //                   children: [MapPage(), RandomPage()],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     } else if (snapshot.hasError) {
    //       return Scaffold(body: Center(child: Text(snapshot.error.toString())));
    //     } else {
    //       return Scaffold(body: Center(child: Text("Loading...")));
    //     }
    //   },
    // );
  }
}

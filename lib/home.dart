import 'package:doxfood/models.dart';
import 'package:doxfood/pages/map/page.dart';
import 'package:doxfood/pages/random/page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var places = context.read<PlacesModel>();
    places.loadPlaces();
  }

  // This widget is the home page of your application. It is stateful, meaning
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: <Widget>[
      //     IconButton(
      //       icon: const Icon(Icons.account_circle),
      //       tooltip: "User",
      //       onPressed: () => {},
      //     ),
      //   ],
      //   // title: const Text("DOXFOOD"),
      // ),
      resizeToAvoidBottomInset: false,
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: TabBar(
            tabs: [Tab(icon: Icon(Icons.map)), Tab(icon: Icon(Icons.casino))],
            isScrollable: false,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).hintColor, width: 3.0),
              ),
            ),
          ),
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [MapPage(), RandomPage()],
          ),
        ),
      ),
    );
  }
}

import 'package:doxfood/pages/map/page.dart';
import 'package:doxfood/pages/random/page.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).hintColor,
                    width: 3.0,
                  ),
                ),
              ),
            ),
            body: const TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [MapPage(), RandomPage()],
            ),
          ),
        ),
      ),
    );
  }
}

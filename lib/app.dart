import 'package:doxfood/api.dart';
import 'package:doxfood/home.dart';
import 'package:doxfood/pages/servers_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: "/servers",
      builder: (BuildContext context, GoRouterState state) {
        return const ServersListPage();
      },
    ),
    GoRoute(
      path: "/home",
      builder: (BuildContext context, GoRouterState state) {
        print("build homepage");
        return HomePage(api: state.extra as API);
      },
    ),
  ],
);

class App extends StatelessWidget {
  final API? initialAPI;

  const App({super.key, this.initialAPI});

  @override
  Widget build(BuildContext context) {
    if (initialAPI == null) {
      _router.go("/servers");
    } else {
      _router.go("/home", extra: initialAPI);
    }

    return MaterialApp.router(
      title: "DOXFOOD",
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      routerConfig: _router,
    );
  }
}

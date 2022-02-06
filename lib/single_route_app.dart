import 'package:flutter/material.dart';

// See https://github.com/flutter/flutter/issues/70358#issuecomment-730686317
void runSingleRouteApp({
  Key? key,
  required String title,
  required Widget home,
  ThemeData? theme,
  ThemeData? darkTheme,
  ThemeMode? themeMode,
}) {
  runApp(MaterialApp.router(
    key: key,
    title: title,
    routeInformationParser: _RouteInformationParser(),
    routerDelegate: _RouterDelegate(home),
    theme: theme,
    darkTheme: darkTheme,
    themeMode: themeMode,
  ));
}

class _RouteInformationParser extends RouteInformationParser<Object> {
  @override
  Future<Object> parseRouteInformation(RouteInformation routeInformation) async => Object();

  @override
  RouteInformation restoreRouteInformation(Object path) => const RouteInformation(location: '/');
}

class _RouterDelegate extends RouterDelegate<Object> with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  final Widget home;

  _RouterDelegate(this.home);

  @override
  Object get currentConfiguration => Object();

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [MaterialPage(child: home)],
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  @override
  Future<Object> setNewRoutePath(Object path) async => Object();
}

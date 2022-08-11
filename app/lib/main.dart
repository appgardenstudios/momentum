import 'package:flutter/material.dart';

import 'package:momentum/page/home.dart';
import 'package:momentum/page/new_project.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouterDelegate _routerDelegate = AppRouterDelegate();
  final AppRouteInformationParser _routeInformationParser =
      AppRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Momentum',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}

class AppRoutePath {
  static const String home = '/';
  static const String newProject = '/new-project';

  final String path;

  const AppRoutePath(this.path);

  bool get isHomePage => path == home;
  bool get isNewProjectPage => path == newProject;
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    return AppRoutePath(uri.path);
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath configuration) {
    return RouteInformation(location: configuration.path);
  }
}

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  AppRoutePath? currentPath;

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  AppRoutePath get currentConfiguration {
    // If no current path, default to the home page
    if (currentPath == null) {
      return const AppRoutePath(AppRoutePath.home);
    }
    return currentPath!;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (currentConfiguration.isNewProjectPage)
          const NewProjectPage()
        else
          HomePage(this),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    currentPath = configuration;
    notifyListeners();
  }

  void navigate(String path) {
    currentPath = AppRoutePath(path);
    notifyListeners();
  }
}

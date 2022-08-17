import 'dart:io' show Directory;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:momentum/page/home.dart';
import 'package:momentum/page/new_project.dart';
import 'package:momentum/page/new_task.dart';
import 'package:momentum/wren.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Directory result = await getApplicationSupportDirectory();
  log(result.absolute.path);
  await Wren.init(path: join(result.path, 'momentum.db'));

  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  static const title = 'GoRouter Example: Declarative Routes';

  late final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            HomePage(projectId: state.queryParams['project']),
        routes: [
          GoRoute(
            path: 'new-project',
            builder: (context, state) => const NewProjectPage(),
          ),
          GoRoute(
            path: 'new-task',
            builder: (context, state) => const NewTaskPage(),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Momentum',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: _router.routeInformationProvider,
      routerDelegate: _router.routerDelegate,
    );
  }
}

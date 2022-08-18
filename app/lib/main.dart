import 'dart:async';
import 'dart:io' show Directory, exit;
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:momentum/page/home.dart';
import 'package:momentum/page/new_project.dart';
import 'package:momentum/page/new_task.dart';
import 'package:momentum/wren.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) {
      // TODO error reporting?
      print("Error From INSIDE FRAME_WORK");
      print("----------------------");
      print("Error :  ${details.exception}");
      print("StackTrace :  ${details.stack}");
      FlutterError.presentError(details);
      if (kReleaseMode) exit(1);
    };

    final Directory result = await getApplicationSupportDirectory();
    log(result.absolute.path);
    await Wren.init(path: join(result.path, 'momentum.db'));

    runApp(App());
  }, (error, stack) {
    // TODO error reporting?
    print("Error FROM OUT_SIDE FRAMEWORK ");
    print("--------------------------------");
    print("Error :  $error");
    print("StackTrace :  $stack");
    if (kReleaseMode) exit(1);
  });
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  var uuid = const Uuid();

  late final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomePage(
          // Always rebuild the home page after navigating elsewhere
          // TODO there has to be a better way
          key: ValueKey(uuid.v4()),
        ),
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

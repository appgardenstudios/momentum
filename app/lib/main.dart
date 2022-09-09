import 'dart:io' show Directory;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:momentum/page/home.dart';
import 'package:momentum/page/new_project.dart';
import 'package:momentum/page/manage_project.dart';
import 'package:momentum/page/complete_project.dart';
import 'package:momentum/page/new_task.dart';
import 'package:momentum/page/manage_task.dart';
import 'package:momentum/page/complete_task.dart';
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

  final Uuid uuid = const Uuid();

  late final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        // Use page builder so we can force the home page to not maintain state
        pageBuilder: (context, state) => MaterialPage(
            child: HomePage(
              projectId: state.queryParams['project'],
            ),
            maintainState: false),
        routes: [
          GoRoute(
            path: 'new-project',
            builder: (context, state) => const NewProjectPage(),
          ),
          GoRoute(
            path: 'new-task/:projectId',
            builder: (context, state) => NewTaskPage(
              projectId: state.params['projectId']!,
            ),
          ),
          GoRoute(
            path: 'project/:projectId/task/:taskId',
            builder: (context, state) => ManageTaskPage(
              projectId: state.params['projectId']!,
              taskId: state.params['taskId']!,
            ),
          ),
          GoRoute(
            path: 'project/:projectId/task/:taskId/complete',
            builder: (context, state) => CompleteTaskPage(
              projectId: state.params['projectId']!,
              taskId: state.params['taskId']!,
            ),
          ),
          GoRoute(
            path: 'project/:projectId',
            builder: (context, state) => ManageProjectPage(
              projectId: state.params['projectId']!,
            ),
            routes: [
              GoRoute(
                path: 'complete',
                builder: (context, state) => CompleteProjectPage(
                  projectId: state.params['projectId']!,
                ),
              ),
            ],
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
        primarySwatch: Colors.deepPurple,
      ),
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: _router.routeInformationProvider,
      routerDelegate: _router.routerDelegate,
    );
  }
}

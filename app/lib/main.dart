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
            path: 'new-task/:projectId',
            builder: (context, state) => NewTaskPage(
              projectId: state.params['projectId']!,
            ),
          ),
          GoRoute(
            path: 'task/:taskId',
            builder: (context, state) => ManageTaskPage(
              taskId: state.params['taskId']!,
            ),
          ),
          GoRoute(
            path: 'task/:taskId/complete',
            builder: (context, state) => CompleteTaskPage(
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
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: _router.routeInformationProvider,
      routerDelegate: _router.routerDelegate,
    );
  }
}

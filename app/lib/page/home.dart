import 'package:flutter/material.dart';

import 'package:momentum/main.dart';
import 'package:momentum/boring.dart';
import 'package:momentum/wren.dart';
import 'package:momentum/data/project.dart';

class HomePage extends Page {
  const HomePage(this.d, {Key? key}) : super(key: const ValueKey("/"));

  final AppRouterDelegate d;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return HomeScreen(d);
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen(this.d, {Key? key}) : super(key: key);

  final AppRouterDelegate d;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;
  Project? project;

  @override
  void initState() {
    super.initState();
    _getProject();
  }

  void _getProject() async {
    // TODO handle error
    var p = await Wren.getProject();
    setState(() {
      loading = false;
      project = p;
    });
  }

  _createProject() {
    widget.d.navigate(AppRoutePath.newProject);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return loadingView(context);
    }
    if (project == null) {
      return welcomeView(context);
    }
    return projectView(context);
  }

  Widget loadingView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome!'),
        centerTitle: false,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget welcomeView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome!'),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
                margin: const EdgeInsets.only(bottom: 32.0),
                child: const BoringText(
                  'Momentum helps you break a project down into bite-sized pieces so you can work on it every single day.',
                  textAlign: TextAlign.center,
                )),
            BoringButton(
              'Create Project',
              onPressed: _createProject,
            ),
          ],
        ),
      ),
    );
  }

  Widget projectView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project!.name),
        centerTitle: false,
      ),
      body: const Center(
        child: BoringText(
          'Project Loaded',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

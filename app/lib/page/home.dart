import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:momentum/boring.dart';
import 'package:momentum/wren.dart';
import 'package:momentum/data/project.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.projectId, Key? key}) : super(key: key);

  final String? projectId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = true;
  Project? project;

  @override
  void initState() {
    super.initState();
    _getProject();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.projectId != oldWidget.projectId) {
      _getProject();
    }
  }

  void _getProject() async {
    setState(() {
      loading = true;
    });
    // TODO handle error
    var p = await Wren.getProject();
    setState(() {
      loading = false;
      project = p;
    });
  }

  _createProject() {
    context.go('/new-project');
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

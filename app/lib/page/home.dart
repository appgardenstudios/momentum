import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:momentum/boring.dart';
import 'package:momentum/wren.dart';
import 'package:momentum/data/project.dart';
import 'package:momentum/data/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = true;
  Project? project;
  List<Task>? tasks;

  @override
  void initState() {
    super.initState();
    log('initState');
    _getData();
  }

  void _getData() async {
    setState(() {
      loading = true;
    });
    var p = await Wren.getProject();
    var t = await Wren.getTasks();
    if (!mounted) return;
    setState(() {
      loading = false;
      project = p;
      tasks = t;
    });
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
              onPressed: () => context.go('/new-project'),
            ),
          ],
        ),
      ),
    );
  }

  Widget projectView(BuildContext context) {
    List<Widget> taskWidgets = [];
    taskWidgets.addAll(tasks!.map((t) => BoringCard(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoringH5(t.name),
            Padding(
                padding: const EdgeInsets.only(top: 4),
                child: BoringText(t.description)),
            Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    BoringLink('View',
                        onPressed: () => {context.go('/task/${t.id}')}),
                    const Spacer(),
                    BoringButton(
                      'Done',
                      onPressed: () => context.go('/task/${t.id}/complete'),
                    ),
                  ],
                )),
          ],
        ))));

    if (taskWidgets.length < 3) {
      taskWidgets.add(BoringCard(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BoringH5('The Next Thing'),
          const Padding(
              padding: EdgeInsets.only(top: 4),
              child: BoringText(
                  'Set the next thing you need to do by creating a task.')),
          Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const Spacer(),
                  BoringButton(
                    'Create Task',
                    onPressed: () => context.go('/new-task'),
                  ),
                ],
              )),
        ],
      )));
    } else {
      taskWidgets.add(const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Center(
              child: BoringCaption('Complete a task before adding another.'))));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(project!.name),
        centerTitle: false,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 8),
          constraints: const BoxConstraints(
            minWidth: 100,
            maxWidth: 320,
            minHeight: double.infinity,
            maxHeight: double.infinity,
          ),
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: taskWidgets,
          ),
        ),
      ),
    );
  }
}

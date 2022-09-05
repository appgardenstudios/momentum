import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
  List<Project> projects = [];
  int currentOffset = 0;
  Map<String, List<Task>> tasks = {};

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
    var p = await Wren.getProjects();
    var map = p.map((e) => e.id).toList();
    var t = await Wren.getTaskMap(map);
    if (!mounted) return;
    setState(() {
      loading = false;
      projects = p;
      tasks = t;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return loadingView(context);
    }
    if (projects.isEmpty) {
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
    AppBar appBar;
    if (currentOffset < projects.length) {
      appBar = AppBar(
        title: Text(projects[currentOffset].name),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Manage Project',
            onPressed: (() {
              context.go('/project/${projects[currentOffset].id}');
            }),
          ),
        ],
      );
    } else {
      appBar = AppBar(
        title: const Text('New Project'),
        centerTitle: false,
      );
    }

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 100,
            maxWidth: 320,
            minHeight: double.infinity,
            maxHeight: double.infinity,
          ),
          child: Column(children: [
            Expanded(
              child: CarouselSlider(
                items: getProjectWidgets(context),
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height -
                      -appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentOffset = index;
                    });
                  },
                ),
              ),
            ),
            // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            //   Text("Navigator area"),
            // ]),
          ]),
        ),
      ),
      // body: Center(
      //   child: Container(
      //     padding: const EdgeInsets.only(top: 8),
      //     constraints: const BoxConstraints(
      //       minWidth: 100,
      //       maxWidth: 320,
      //       minHeight: double.infinity,
      //       maxHeight: double.infinity,
      //     ),
      //     child: ListView.separated(
      //       padding: const EdgeInsets.all(8),
      //       itemCount: taskWidgets.length,
      //       separatorBuilder: (BuildContext context, int index) =>
      //           const SizedBox(height: 8),
      //       itemBuilder: (BuildContext context, int index) {
      //         return taskWidgets.elementAt(index);
      //       },
      //     ),
      //   ),
      // ),
    );
  }

  List<Widget> getProjectWidgets(BuildContext context) {
    List<Widget> projectWidgets = [];

    projectWidgets.addAll(projects.map((p) {
      var projectTasks = getProjectTasks(context, p.id);

      return ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: projectTasks.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 8),
        itemBuilder: (BuildContext context, int index) {
          return projectTasks.elementAt(index);
        },
      );
    }));

    if (projectWidgets.length < 3) {
      projectWidgets.add(Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
                margin: const EdgeInsets.only(bottom: 32.0),
                child: const BoringText(
                  'You can create up to 3 projects',
                  textAlign: TextAlign.center,
                )),
            BoringButton(
              'Create Another',
              onPressed: () => context.go('/new-project'),
            ),
          ],
        ),
      ));
    } else {
      projectWidgets.add(Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
                margin: const EdgeInsets.only(bottom: 32.0),
                child: const BoringText(
                  'Complete a project before adding another.',
                  textAlign: TextAlign.center,
                )),
          ],
        ),
      ));
    }

    return projectWidgets;
  }

  List<Widget> getProjectTasks(BuildContext context, String projectId) {
    List<Widget> taskWidgets = [];
    taskWidgets.addAll(tasks[projectId]!.map((t) => BoringCard(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoringH5(t.name),
            Padding(
                padding: const EdgeInsets.only(top: 4),
                child: BoringText(t.description)),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    BoringLink('Edit',
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
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  const Spacer(),
                  BoringButton(
                    'Create Task',
                    onPressed: () => context.go('/new-task/$projectId'),
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
    return taskWidgets;
  }
}

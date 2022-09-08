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
  Map<String, List<Task>> tasks = {};
  int currentOffset = 0;
  final CarouselController carouselController = CarouselController();

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
    double width = MediaQuery.of(context).size.width;
    if (width >= 960) {
      return multiColumnProjectView(context, width);
    }
    return singleColumnProjectView(context);
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

  Widget multiColumnProjectView(BuildContext context, double width) {
    double itemWidth =
        (width - (16 * (projects.length + 1))) / (projects.length + 1);
    if (itemWidth > 320) {
      itemWidth = 320;
    }
    List<Widget> projectWidgets = [];

    projectWidgets.addAll(projects.map((p) {
      List<Widget> items = [];
      items.add(Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: BoringH4(p.name),
      ));

      List<Widget> projectTasks = getProjectTasks(context, p.id);
      for (var i = 0; i < projectTasks.length; i++) {
        items.add(projectTasks[i]);
        if (i != projectTasks.length - 1) {
          items.add(const SizedBox(height: 8));
        }
      }

      items.add(Padding(
          padding: const EdgeInsets.only(top: 8),
          child: BoringLink(
            'Manage Project',
            onPressed: () => context.go('/project/${p.id}'),
          )));

      return Container(
        constraints: BoxConstraints(minWidth: 100, maxWidth: itemWidth),
        margin: const EdgeInsets.only(top: 16, left: 16),
        child: Column(
          children: items,
        ),
      );
    }));

    if (projectWidgets.length < 3) {
      projectWidgets.add(Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                constraints: BoxConstraints(minWidth: 100, maxWidth: itemWidth),
                margin: const EdgeInsets.only(top: 24),
                padding: const EdgeInsets.all(16),
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
                constraints: BoxConstraints(minWidth: 100, maxWidth: itemWidth),
                margin: const EdgeInsets.only(top: 56),
                padding: const EdgeInsets.all(16),
                child: const BoringText(
                  'Complete a project before adding another.',
                  textAlign: TextAlign.center,
                )),
          ],
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Momentum'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: projectWidgets,
          ),
        ),
      ),
    );
  }

  Widget singleColumnProjectView(BuildContext context) {
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

    List<Widget> projectWidgets = getProjectWidgets(context);

    List<Widget> navDots = projectWidgets.asMap().entries.map((entry) {
      return GestureDetector(
        onTap: () => carouselController.animateToPage(entry.key),
        child: Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.only(top: 17, bottom: 17, left: 8, right: 8),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black)
                  .withOpacity(currentOffset == entry.key ? 0.9 : 0.4)),
        ),
      );
    }).toList();

    List<Widget> navBar = [];

    navBar.add(Visibility(
      visible: currentOffset != 0,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Previous Project',
        onPressed: () => carouselController.animateToPage(currentOffset - 1),
      ),
    ));
    navBar.add(const Spacer());
    navBar.addAll(navDots);
    navBar.add(const Spacer());
    navBar.add(Visibility(
      visible: currentOffset != projectWidgets.length - 1,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: IconButton(
        icon: const Icon(Icons.arrow_forward),
        tooltip: 'Previous Project',
        onPressed: () => carouselController.animateToPage(currentOffset + 1),
      ),
    ));

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
                items: projectWidgets,
                carouselController: carouselController,
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height -
                      -appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top -
                      48,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: navBar,
            ),
          ]),
        ),
      ),
    );
  }

  List<Widget> getProjectWidgets(BuildContext context) {
    List<Widget> projectWidgets = [];

    projectWidgets.addAll(projects.map((p) {
      List<Widget> projectTasks = getProjectTasks(context, p.id);

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

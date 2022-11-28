import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:momentum/boring.dart';
import 'package:momentum/copy.dart';
import 'package:momentum/wren.dart';
import 'package:momentum/data/project.dart';
import 'package:momentum/data/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.projectId, Key? key}) : super(key: key);

  final String? projectId;

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
    _getData();
  }

  void _getData() async {
    setState(() {
      loading = true;
    });
    // Get data
    var p = await Wren.getProjects();
    var map = p.map((e) => e.id).toList();
    var t = await Wren.getTaskMap(map);
    // Set currentOffset to passed in project id
    int co = 0;
    if (widget.projectId != null) {
      p.asMap().forEach((index, project) {
        if (project.id == widget.projectId) {
          co = index;
        }
      });
    }
    if (!mounted) return;
    setState(() {
      loading = false;
      projects = p;
      tasks = t;
      currentOffset = co;
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
        title: Text(Copy.home.welcome),
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
        title: Text(Copy.home.welcome),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
                margin: const EdgeInsets.only(bottom: 32.0),
                child: BoringText(
                  Copy.home.initialPrompt,
                  textAlign: TextAlign.center,
                )),
            BoringButton(
              Copy.home.createProject,
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
    List<Widget> headerWidgets = [];
    List<Widget> projectWidgets = [];

    headerWidgets.addAll(projects.map((p) {
      return Container(
        constraints: BoxConstraints(minWidth: itemWidth, maxWidth: itemWidth),
        margin: const EdgeInsets.only(top: 4, left: 16),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: BoringH4(
            p.name,
            textAlign: TextAlign.center,
            color: const Color(0xFF4527A0),
          ),
        ),
      );
    }));

    projectWidgets.addAll(projects.map((p) {
      List<Widget> items = [];

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
            Copy.home.manageProject,
            onPressed: () => context.go('/project/${p.id}'),
          )));

      return Container(
        constraints: BoxConstraints(minWidth: itemWidth, maxWidth: itemWidth),
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
                constraints:
                    BoxConstraints(minWidth: itemWidth, maxWidth: itemWidth),
                margin: const EdgeInsets.only(top: 0),
                padding: const EdgeInsets.all(16),
                child: BoringText(
                  Copy.home.createAnotherProjectPrompt,
                  textAlign: TextAlign.center,
                )),
            BoringButton(
              Copy.home.createAnotherProject,
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
                constraints:
                    BoxConstraints(minWidth: itemWidth, maxWidth: itemWidth),
                margin: const EdgeInsets.only(top: 0),
                padding: const EdgeInsets.all(16),
                child: BoringText(
                  Copy.home.maxProjectsPrompt,
                  textAlign: TextAlign.center,
                )),
          ],
        ),
      ));
    }

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(children: headerWidgets),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: projectWidgets,
            ),
          ),
        )
      ],
    ));
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
            tooltip: Copy.home.manageProject,
            onPressed: (() {
              context.go('/project/${projects[currentOffset].id}');
            }),
          ),
        ],
      );
    } else {
      appBar = AppBar(
        title: Text(Copy.home.newProject),
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
        tooltip: Copy.home.previousProject,
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
        tooltip: Copy.home.nextProject,
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
                  initialPage: currentOffset,
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
                child: BoringText(
                  Copy.home.createAnotherProjectPrompt,
                  textAlign: TextAlign.center,
                )),
            BoringButton(
              Copy.home.createAnotherProject,
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
                child: BoringText(
                  Copy.home.maxProjectsPrompt,
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
                    BoringLink(Copy.home.editTask,
                        onPressed: () =>
                            {context.go('/project/$projectId/task/${t.id}')}),
                    const Spacer(),
                    BoringButton(
                      Copy.home.completeTask,
                      onPressed: () => context
                          .go('/project/$projectId/task/${t.id}/complete'),
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
          BoringH5(Copy.home.newTaskTitle),
          Padding(
              padding: const EdgeInsets.only(top: 4),
              child: BoringText(Copy.home.newTaskDescription)),
          Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  const Spacer(),
                  BoringButton(
                    Copy.home.newTask,
                    onPressed: () => context.go('/new-task/$projectId'),
                  ),
                ],
              )),
        ],
      )));
    } else {
      taskWidgets.add(Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Center(
              child: BoringCaption(
            Copy.home.maxTasksPrompt,
            textAlign: TextAlign.center,
          ))));
    }
    return taskWidgets;
  }
}

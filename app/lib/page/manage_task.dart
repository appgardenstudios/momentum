import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:momentum/boring.dart';
import 'package:momentum/wren.dart';
import 'package:momentum/data/task.dart';

class ManageTaskPage extends StatefulWidget {
  const ManageTaskPage({required this.taskId, Key? key}) : super(key: key);

  final String taskId;

  @override
  State<ManageTaskPage> createState() => _ManageTaskPageState();
}

class _ManageTaskPageState extends State<ManageTaskPage> {
  bool loading = true;
  ManageTaskMode mode = ManageTaskMode.view;
  Task? task;

  @override
  void initState() {
    super.initState();
    _getTask();
  }

  void _getTask() async {
    setState(() {
      loading = true;
    });
    var t = await Wren.getTask(widget.taskId);
    setState(() {
      loading = false;
      task = t;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return loadingView(context);
    }
    return taskView(context);
  }

  Widget loadingView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Task'),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget taskView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Task'),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
            constraints: const BoxConstraints(
              minWidth: 100,
              maxWidth: 320,
              minHeight: double.infinity,
              maxHeight: double.infinity,
            ),
            child: ListView(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        const BoringH6('Name'),
                        const Spacer(),
                        BoringLink('Edit',
                            onPressed: () => {
                                  setState(
                                    () => mode = ManageTaskMode.edit,
                                  )
                                }),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: BoringText(task!.name)),
                const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: BoringH6('Description')),
                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: BoringText(task!.description)),
                Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        BoringLink('Delete',
                            onPressed: () => {
                                  setState(
                                    () => mode = ManageTaskMode.delete,
                                  )
                                }),
                        const Spacer(),
                        BoringButton('Back',
                            onPressed: () => {context.go('/')}),
                      ],
                    )),
              ],
            )),
      ),
    );
  }
}

enum ManageTaskMode {
  view,
  edit,
  delete,
}

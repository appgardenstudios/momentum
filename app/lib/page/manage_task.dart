import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:momentum/boring.dart';
import 'package:momentum/copy.dart';
import 'package:momentum/wren.dart';
import 'package:momentum/data/task.dart';

class ManageTaskPage extends StatefulWidget {
  const ManageTaskPage(
      {required this.projectId, required this.taskId, Key? key})
      : super(key: key);

  final String projectId;
  final String taskId;

  @override
  State<ManageTaskPage> createState() => _ManageTaskPageState();
}

class _ManageTaskPageState extends State<ManageTaskPage> {
  bool loading = true;
  bool deleting = false;
  Task? task;

  final _formKey = GlobalKey<FormState>();
  String taskName = '';
  String taskDescription = '';

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

  _saveTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await Wren.updateTask(
          id: task!.id, name: taskName, description: taskDescription);

      if (!mounted) return;
      context.go('/?project=${widget.projectId}');
    }
  }

  void _deleteTask() async {
    await Wren.updateTaskStatus(id: widget.taskId, status: 'deleted');

    if (!mounted) return;
    context.go('/?project=${widget.projectId}');
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return loadingView(context);
    }
    if (deleting) {
      return deleteView(context);
    }
    return editView(context);
  }

  Widget loadingView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Copy.manageTask.editTitle),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget editView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Copy.manageTask.editTitle),
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
            child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            BoringH6(Copy.manageTask.nameTitle),
                            const Spacer(),
                            BoringLink(Copy.manageTask.delete,
                                onPressed: () => {
                                      setState(
                                        () => deleting = true,
                                      )
                                    }),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: BoringTextFormField(
                        initialValue: task!.name,
                        hint: Copy.manageTask.nameHint,
                        onSaved: (value) => taskName = value!.trim(),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.trim().length > 32) {
                            return Copy.manageTask.nameError;
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: BoringH6(Copy.manageTask.descriptionTitle),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: BoringTextFormField(
                        initialValue: task!.description,
                        hint: Copy.manageTask.descriptionHint,
                        onSaved: (value) =>
                            taskDescription = value != null ? value.trim() : '',
                        validator: (value) {
                          return null;
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            BoringLink(Copy.manageTask.cancel,
                                onPressed: () => {
                                      context
                                          .go('/?project=${widget.projectId}')
                                    }),
                            const Spacer(),
                            BoringButton(Copy.manageTask.save,
                                onPressed: _saveTask)
                          ],
                        )),
                  ],
                ))),
      ),
    );
  }

  Widget deleteView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Copy.manageTask.deleteTitle),
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
            child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: BoringH6(Copy.manageTask.deletePrompt(task!.name)),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            BoringText(Copy.manageTask.areYouSure),
                            const Spacer(),
                            BoringButton(Copy.manageTask.no,
                                onPressed: () => {
                                      setState(
                                        () => deleting = false,
                                      )
                                    }),
                            const Spacer(),
                            BoringButton(Copy.manageTask.yes,
                                onPressed: _deleteTask),
                          ],
                        )),
                  ],
                ))),
      ),
    );
  }
}

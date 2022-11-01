import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:momentum/boring.dart';
import 'package:momentum/copy.dart';
import 'package:momentum/data/project.dart';
import 'package:momentum/wren.dart';

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({required this.projectId, Key? key}) : super(key: key);

  final String projectId;

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  bool loading = true;
  Project? project;

  String taskName = '';
  String taskDescription = '';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getProject();
  }

  void _getProject() async {
    setState(() {
      loading = true;
    });
    var p = await Wren.getProject(widget.projectId);
    setState(() {
      loading = false;
      project = p;
    });
  }

  _createTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await Wren.createTask(
          projectId: project!.id, name: taskName, description: taskDescription);

      if (!mounted) return;
      context.go('/?project=${project!.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return loadingView(context);
    }
    return formView(context);
  }

  Widget loadingView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Copy.newTask.title),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget formView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Copy.newTask.title),
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
                        child: BoringH6(Copy.newTask.nameTitle)),
                    Padding(
                        padding: const EdgeInsets.only(top: 4, left: 8),
                        child: BoringText(
                            Copy.newTask.namePrompt(project!.taskTime))),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: BoringTextFormField(
                        hint: Copy.newTask.nameHint,
                        onSaved: (value) => taskName = value!.trim(),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.trim().length > 64) {
                            return Copy.newTask.nameError;
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: BoringH6(Copy.newTask.descriptionTitle),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 4, left: 8),
                        child: BoringText(Copy.newTask.descriptionPrompt)),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: BoringTextFormField(
                        hint: Copy.newTask.descriptionHint,
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
                            BoringLink(Copy.newTask.cancel,
                                onPressed: () => {
                                      context
                                          .go('/?project=${widget.projectId}')
                                    }),
                            const Spacer(),
                            BoringButton(Copy.newTask.save,
                                onPressed: _createTask)
                          ],
                        )),
                  ],
                ))),
      ),
    );
  }
}

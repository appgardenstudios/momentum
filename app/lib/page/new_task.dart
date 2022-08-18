import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:momentum/boring.dart';
import 'package:momentum/data/project.dart';
import 'package:momentum/wren.dart';

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({Key? key}) : super(key: key);

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
    var p = await Wren.getProject();
    setState(() {
      loading = false;
      project = p;
    });
  }

  _createTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var id =
          await Wren.createTask(name: taskName, description: taskDescription);

      if (!mounted) return;
      GoRouter.of(context).go('/?task=$id');
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
        title: const Text('Welcome!'),
        centerTitle: false,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget formView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Project'),
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
                    const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child:
                            BoringH6('What is the next thing you need to do?')),
                    Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: BoringText(
                            'Remember, you need to be able to complete this in ${project!.taskTime}!')),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: BoringTextFormField(
                        hint: 'Task Name',
                        onSaved: (value) => taskName = value!,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length > 32) {
                            return 'Must be between 1 and 32 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const BoringH6('Any other details or thoughts?'),
                    const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: BoringText(
                            'Go ahead and jot down some details and thoughts.')),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: BoringTextFormField(
                        hint: 'Task Details',
                        onSaved: (value) => taskDescription = value ?? '',
                        validator: (value) {
                          return null;
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            BoringLink('Cancel',
                                onPressed: () => {context.pop()}),
                            const Spacer(),
                            BoringButton('Go', onPressed: _createTask)
                          ],
                        )),
                  ],
                ))),
      ),
    );
  }
}

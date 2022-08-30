import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:momentum/boring.dart';
import 'package:momentum/wren.dart';
import 'package:momentum/data/project.dart';

class ManageProjectPage extends StatefulWidget {
  const ManageProjectPage({required this.projectId, Key? key})
      : super(key: key);

  final String projectId;

  @override
  State<ManageProjectPage> createState() => _ManageProjectPageState();
}

class _ManageProjectPageState extends State<ManageProjectPage> {
  bool loading = true;
  Project? project;

  final _formKey = GlobalKey<FormState>();
  String projectName = '';
  String projectTaskTime = '';

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

  _saveProject() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await Wren.updateProject(
          id: project!.id, name: projectName, taskTime: projectTaskTime);

      if (!mounted) return;
      context.go('/');
    }
  }

  void _closeProject() async {
    await Wren.updateProjectStatus(id: widget.projectId, status: 'done');
    if (!mounted) return;
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return loadingView(context);
    }
    return editView(context);
  }

  Widget loadingView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Project'),
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
        title: const Text('Edit Project'),
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
                        child: BoringH6('Name')),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: BoringTextFormField(
                        initialValue: project!.name,
                        hint: 'Project Name',
                        onSaved: (value) => projectName = value!,
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
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: BoringH6('Task Time'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: BoringTextFormField(
                        initialValue: project!.taskTime,
                        hint: 'Task Details',
                        onSaved: (value) => projectTaskTime = value!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Must not be blank';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            BoringLink('Cancel',
                                onPressed: () => {context.go('/')}),
                            const Spacer(),
                            BoringButton('Save', onPressed: _saveProject)
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 64),
                      child: Column(
                        children: [
                          const BoringH6('Project Done?'),
                          const SizedBox(height: 8),
                          BoringButton('Complete', onPressed: _closeProject)
                        ],
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }
}

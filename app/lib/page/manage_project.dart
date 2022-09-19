import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:momentum/boring.dart';
import 'package:momentum/copy.dart';
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
    var p = await Wren.getProject(widget.projectId);
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
      context.go('/?project=${widget.projectId}');
    }
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
        title: Text(Copy.manageProject.title),
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
        title: Text(Copy.manageProject.title),
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
                        child: BoringH6(Copy.manageProject.nameTitle)),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: BoringTextFormField(
                        initialValue: project!.name,
                        hint: Copy.manageProject.nameHint,
                        onSaved: (value) => projectName = value!.trim(),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.trim().length > 32) {
                            return Copy.manageProject.nameError;
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: BoringH6(Copy.manageProject.timeTitle),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: BoringTextFormField(
                        initialValue: project!.taskTime,
                        hint: Copy.manageProject.timeHint,
                        onSaved: (value) => projectTaskTime = value!.trim(),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return Copy.manageProject.timeError;
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            BoringLink(Copy.manageProject.cancel,
                                onPressed: () => {
                                      context
                                          .go('/?project=${widget.projectId}')
                                    }),
                            const Spacer(),
                            BoringButton(Copy.manageProject.save,
                                onPressed: _saveProject)
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 64),
                      child: BoringLink(Copy.manageProject.complete,
                          onPressed: () => {
                                context
                                    .go('/project/${widget.projectId}/complete')
                              }),
                    ),
                  ],
                ))),
      ),
    );
  }
}

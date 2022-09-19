import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:momentum/boring.dart';
import 'package:momentum/copy.dart';
import 'package:momentum/wren.dart';

class NewProjectPage extends StatefulWidget {
  const NewProjectPage({Key? key}) : super(key: key);

  @override
  State<NewProjectPage> createState() => _NewProjectPageState();
}

class _NewProjectPageState extends State<NewProjectPage> {
  String projectName = '';
  String projectTaskTime = '';

  final _formKey = GlobalKey<FormState>();

  _createProject() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String id = await Wren.createProject(
          name: projectName, taskTime: projectTaskTime);

      if (!mounted) return;
      context.go('/?project=$id');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Copy.newProject.title),
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
                        child: BoringH6(Copy.newProject.nameTitle)),
                    Padding(
                        padding: const EdgeInsets.only(top: 4, left: 8),
                        child: BoringText(Copy.newProject.namePrompt)),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: BoringTextFormField(
                        hint: Copy.newProject.nameHint,
                        onSaved: (value) => projectName = value!.trim(),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.trim().length > 32) {
                            return Copy.newProject.nameError;
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: BoringH6(Copy.newProject.timeTitle),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 4, left: 8),
                        child: BoringText(Copy.newProject.timePrompt)),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: BoringTextFormField(
                        hint: Copy.newProject.timeHint,
                        onSaved: (value) => projectTaskTime = value!.trim(),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return Copy.newProject.timeError;
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            BoringLink(Copy.newProject.cancel,
                                onPressed: () => {context.go('/')}),
                            const Spacer(),
                            BoringButton(Copy.newProject.save,
                                onPressed: _createProject)
                          ],
                        )),
                  ],
                ))),
      ),
    );
  }
}

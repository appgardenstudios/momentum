import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:momentum/boring.dart';
import 'package:momentum/wren.dart';

class NewProjectPage extends StatefulWidget {
  const NewProjectPage({Key? key}) : super(key: key);

  @override
  State<NewProjectPage> createState() => _NewProjectPageState();
}

class _NewProjectPageState extends State<NewProjectPage> {
  String saveError = '';

  String projectName = '';
  String projectTaskTime = '';

  final _formKey = GlobalKey<FormState>();

  _createProject() async {
    setState(() {
      saveError = '';
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        var id = await Wren.createProject(
            name: projectName, taskTime: projectTaskTime);

        if (!mounted) return;
        GoRouter.of(context).go('/?project=$id');
      } catch (err) {
        setState(() {
          saveError = 'Could not save. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        child: BoringH6('What is your project named?')),
                    const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: BoringText(
                            'It can be a working name, an actual name, or a silly made-up name.')),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: BoringTextFormField(
                        hint: 'My Project',
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
                    const BoringH6(
                        'How much time can you devote to a single task?'),
                    const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: BoringText(
                            'This should be the amount of time you would like to spend working on your project every day in a single session.')),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: BoringTextFormField(
                        hint: '30 Minutes',
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
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            BoringLink('Cancel',
                                onPressed: () =>
                                    {GoRouter.of(context).go('/')}),
                            const Spacer(),
                            BoringButton('Go', onPressed: _createProject)
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: BoringCaption(
                          saveError,
                          textAlign: TextAlign.end,
                          color: const Color(0xffd32f2f),
                        )),
                  ],
                ))),
      ),
    );
  }
}

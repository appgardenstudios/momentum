import 'package:flutter/material.dart';

import 'package:momentum/main.dart';
import 'package:momentum/boring.dart';
import 'package:momentum/wren.dart';

class NewProjectPage extends Page {
  const NewProjectPage(this.d, {Key? key})
      : super(key: const ValueKey("/new-project"));

  final AppRouterDelegate d;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return NewProjectScreen(d);
      },
    );
  }
}

class NewProjectScreen extends StatefulWidget {
  const NewProjectScreen(this.d, {Key? key}) : super(key: key);

  final AppRouterDelegate d;

  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  final String saveError = '';

  String projectName = '';
  String projectTaskTime = '';

  final _formKey = GlobalKey<FormState>();

  _createProject() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO Handle save errors
      var id = await Wren.createProject(
          name: projectName, taskTime: projectTaskTime);
      widget.d.navigate('${AppRoutePath.home}?project=$id');
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
                                    {widget.d.navigate(AppRoutePath.home)}),
                            const Spacer(),
                            BoringButton('Go', onPressed: _createProject)
                          ],
                        )),
                    BoringCaption(
                      saveError,
                      textAlign: TextAlign.end,
                    ),
                  ],
                ))),
      ),
    );
  }
}

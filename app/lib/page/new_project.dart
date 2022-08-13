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
  final String nameError = '';
  final String timeError = '';
  final String saveError = '';

  _createProject() async {
    await Wren.createProject(name: 'Test', taskTime: '30 min');
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
            child: ListView(
              children: [
                const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: BoringH6('What is your project named?')),
                const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: BoringText(
                        'It can be a working name, an actual name, or a silly made-up name.')),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: BoringTextField(),
                ),
                BoringCaption(nameError),
                const BoringH6(
                    'How much time can you devote to a single task?'),
                const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: BoringText(
                        'This should be the amount of time you would like to spend working on your project every day in a single session.')),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: BoringTextField(),
                ),
                BoringCaption(timeError),
                Row(
                  children: [
                    BoringLink('Cancel',
                        onPressed: () =>
                            {widget.d.navigate(AppRoutePath.home)}),
                    const Spacer(),
                    BoringButton('Go', onPressed: _createProject)
                  ],
                ),
                BoringCaption(
                  saveError,
                  textAlign: TextAlign.end,
                ),
              ],
            )),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:momentum/main.dart';
import 'package:momentum/boring.dart';

class NewProjectPage extends Page {
  const NewProjectPage(this.d, {Key? key})
      : super(key: const ValueKey("/new-project"));

  final AppRouterDelegate d;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return NewPageScreen(d);
      },
    );
  }
}

class NewPageScreen extends StatefulWidget {
  const NewPageScreen(this.d, {Key? key}) : super(key: key);

  final AppRouterDelegate d;

  @override
  State<NewPageScreen> createState() => _NewPageScreenState();
}

class _NewPageScreenState extends State<NewPageScreen> {
  final String nameError = '';
  final String timeError = '';
  final String saveError = '';

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
                  child: BoringInput(),
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
                  child: BoringInput(),
                ),
                BoringCaption(timeError),
                Row(
                  children: [
                    BoringLink('Cancel',
                        onPressed: () =>
                            {widget.d.navigate(AppRoutePath.home)}),
                    const Spacer(),
                    BoringButton('Go', onPressed: () => {})
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

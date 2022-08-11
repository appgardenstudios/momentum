import 'package:flutter/material.dart';

import 'package:momentum/boring.dart';

class NewProjectPage extends Page {
  const NewProjectPage({Key? key}) : super(key: const ValueKey("/new-project"));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return const NewPageScreen();
      },
    );
  }
}

class NewPageScreen extends StatelessWidget {
  const NewPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Project'),
        centerTitle: false,
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
                const BoringH2('What name would you like to use?'),
                const BoringP(
                    'It can be a working name, an actual name, or a silly made-up name.'),
                const BoringInput(),
                const BoringP('Must be between 1 and 32 characters'),
                const BoringH2(
                    'How much time can you devote to a single task?'),
                const BoringP(
                    'It can be a working name, an actual name, or a silly made-up name.'),
                const BoringInput(),
                const BoringP('Must not be blank'),
                Row(
                  children: [
                    const BoringP('Cancel'),
                    const Spacer(),
                    BoringButton(text: 'Go', onPressed: () => {})
                  ],
                ),
                const BoringP('Could not save. Please try again'),
              ],
            )),
      ),
    );
  }
}

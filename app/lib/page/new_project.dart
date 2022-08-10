import 'package:flutter/material.dart';

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
      body: const Center(
        child: Text('New Project'),
      ),
    );
  }
}

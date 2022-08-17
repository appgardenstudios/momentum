import 'package:flutter/material.dart';

import 'package:momentum/boring.dart';

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({Key? key}) : super(key: key);

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Task'),
          centerTitle: false,
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child: BoringText('New Task'),
        ));
  }
}

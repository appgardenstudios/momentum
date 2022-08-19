import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:momentum/wren.dart';

class CompleteTaskPage extends StatefulWidget {
  const CompleteTaskPage({required this.taskId, Key? key}) : super(key: key);

  final String taskId;

  @override
  State<CompleteTaskPage> createState() => _CompleteTaskPageState();
}

class _CompleteTaskPageState extends State<CompleteTaskPage> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _updateTask();
  }

  void _updateTask() async {
    await Wren.markTaskAsDone(widget.taskId);
    if (!mounted) return;
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return loadingView(context);
  }

  Widget loadingView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Well Done!'),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:momentum/wren.dart';

class CompleteTaskPage extends StatefulWidget {
  const CompleteTaskPage(
      {required this.projectId, required this.taskId, Key? key})
      : super(key: key);

  final String projectId;
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
    await Wren.updateTaskStatus(id: widget.taskId, status: 'done');
    // Wait for a full loop of the gif
    await Future.delayed(const Duration(milliseconds: 750));
    if (!mounted) return;
    context.go('/?project=${widget.projectId}');
  }

  @override
  Widget build(BuildContext context) {
    return confettiView(context);
  }

  Widget confettiView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Well Done!'),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Image.asset(
          "assets/confetti.gif",
          height: 300,
          width: 300,
        ),
      ),
    );
  }
}

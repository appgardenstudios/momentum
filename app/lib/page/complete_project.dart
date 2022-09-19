import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:momentum/boring.dart';
import 'package:momentum/copy.dart';
import 'package:momentum/wren.dart';

class CompleteProjectPage extends StatefulWidget {
  const CompleteProjectPage({required this.projectId, Key? key})
      : super(key: key);

  final String projectId;

  @override
  State<CompleteProjectPage> createState() => _CompleteProjectPageState();
}

class _CompleteProjectPageState extends State<CompleteProjectPage> {
  void _closeProject() async {
    await Wren.updateProjectStatus(id: widget.projectId, status: 'done');
    if (!mounted) return;
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Copy.completeProject.title),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 100,
            maxWidth: 300,
            minHeight: double.infinity,
            maxHeight: double.infinity,
          ),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BoringText(
                Copy.completeProject.prompt,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BoringButton(Copy.completeProject.no,
                      onPressed: () =>
                          {context.go('/project/${widget.projectId}')}),
                  const SizedBox(width: 48),
                  BoringButton(Copy.completeProject.yes,
                      onPressed: _closeProject)
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }
}

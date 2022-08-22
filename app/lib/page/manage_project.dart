import 'package:flutter/material.dart';

class ManageProjectPage extends StatefulWidget {
  const ManageProjectPage({required this.projectId, Key? key})
      : super(key: key);

  final String projectId;

  @override
  State<ManageProjectPage> createState() => _ManageProjectPageState();
}

class _ManageProjectPageState extends State<ManageProjectPage> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return loadingView(context);
  }

  Widget loadingView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Project'),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

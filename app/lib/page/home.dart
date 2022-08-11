import 'package:flutter/material.dart';

import 'package:momentum/main.dart';
import 'package:momentum/boring.dart';

class HomePage extends Page {
  const HomePage(this.d, {Key? key}) : super(key: const ValueKey("/"));

  final AppRouterDelegate d;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return HomeWidget(d);
      },
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget(this.d, {Key? key}) : super(key: key);

  final AppRouterDelegate d;

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  _createProject() {
    widget.d.navigate(AppRoutePath.newProject);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome!'),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
                margin: const EdgeInsets.only(bottom: 32.0),
                child: const BoringH1(
                  'Momentum helps you break a project down into bite-sized pieces so you can work on it every single day.',
                  textAlign: TextAlign.center,
                )),
            BoringButton(
              text: 'Create Project',
              onPressed: _createProject,
            ),
          ],
        ),
      ),
    );
  }
}

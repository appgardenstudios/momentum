import 'package:flutter/material.dart';

class BoringH1 extends StatelessWidget {
  const BoringH1(this.text, {Key? key, this.textAlign = TextAlign.start})
      : super(key: key);

  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 24),
      textAlign: textAlign,
    );
  }
}

class BoringH2 extends StatelessWidget {
  const BoringH2(this.text, {Key? key, this.textAlign = TextAlign.start})
      : super(key: key);

  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20),
      textAlign: textAlign,
    );
  }
}

class BoringP extends StatelessWidget {
  const BoringP(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class BoringInput extends StatelessWidget {
  const BoringInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: '',
      ),
    );
  }
}

enum BoringButtonRole {
  primary,
  secondary,
  success,
  link,
}

class BoringButton extends StatelessWidget {
  const BoringButton(
      {Key? key,
      this.text = '',
      this.role = BoringButtonRole.primary,
      this.onPressed})
      : super(key: key);

  final String text;
  final BoringButtonRole role;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 16),
        padding: const EdgeInsets.all(16.0),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

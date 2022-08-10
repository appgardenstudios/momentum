import 'package:flutter/material.dart';

class BoringH1 extends StatelessWidget {
  const BoringH1(
      {Key? key, required this.text, this.textAlign = TextAlign.start})
      : super(key: key);

  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 24),
      textAlign: TextAlign.center,
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

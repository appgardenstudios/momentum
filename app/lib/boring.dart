import 'package:flutter/material.dart';

// https://material.io/design/typography/the-type-system.html#type-scale

class BoringH1 extends StatelessWidget {
  const BoringH1(this.text, {Key? key, this.textAlign = TextAlign.start})
      : super(key: key);

  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
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
      style: const TextStyle(
          fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5),
      textAlign: textAlign,
    );
  }
}

class BoringH3 extends StatelessWidget {
  const BoringH3(this.text, {Key? key, this.textAlign = TextAlign.start})
      : super(key: key);

  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w400),
      textAlign: textAlign,
    );
  }
}

class BoringH4 extends StatelessWidget {
  const BoringH4(this.text, {Key? key, this.textAlign = TextAlign.start})
      : super(key: key);

  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      textAlign: textAlign,
    );
  }
}

class BoringH5 extends StatelessWidget {
  const BoringH5(this.text, {Key? key, this.textAlign = TextAlign.start})
      : super(key: key);

  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
      textAlign: textAlign,
    );
  }
}

class BoringH6 extends StatelessWidget {
  const BoringH6(this.text, {Key? key, this.textAlign = TextAlign.start})
      : super(key: key);

  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
      textAlign: textAlign,
    );
  }
}

class BoringSubtitle extends StatelessWidget {
  const BoringSubtitle(this.text, {Key? key, this.textAlign = TextAlign.start})
      : super(key: key);

  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
      textAlign: textAlign,
    );
  }
}

class BoringText extends StatelessWidget {
  const BoringText(this.text, {Key? key, this.textAlign = TextAlign.start})
      : super(key: key);

  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
      textAlign: textAlign,
    );
  }
}

class BoringCaption extends StatelessWidget {
  const BoringCaption(this.text,
      {Key? key, this.textAlign = TextAlign.start, this.color})
      : super(key: key);

  final String text;
  final TextAlign textAlign;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: color),
      textAlign: textAlign,
    );
  }
}

class BoringOverline extends StatelessWidget {
  const BoringOverline(this.text, {Key? key, this.textAlign = TextAlign.start})
      : super(key: key);

  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
      textAlign: textAlign,
    );
  }
}

class BoringTextField extends StatelessWidget {
  const BoringTextField({Key? key, this.hint}) : super(key: key);

  final String? hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}

class BoringTextFormField extends StatelessWidget {
  const BoringTextFormField({Key? key, this.validator, this.onSaved, this.hint})
      : super(key: key);

  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onSaved: onSaved,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
  const BoringButton(this.text,
      {Key? key, this.role = BoringButtonRole.primary, this.onPressed})
      : super(key: key);

  final String text;
  final BoringButtonRole role;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 1.25),
        padding: const EdgeInsets.all(16.0),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class BoringLink extends StatelessWidget {
  const BoringLink(this.text, {Key? key, this.onPressed}) : super(key: key);

  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 1.25),
        padding: const EdgeInsets.all(0.0),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

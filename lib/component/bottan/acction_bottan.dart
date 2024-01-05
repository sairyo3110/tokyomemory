import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const ActionButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFF6E6DC),
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240.0,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          onPrimary: textColor,
        ),
      ),
    );
  }
}

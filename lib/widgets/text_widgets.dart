import 'package:flutter/material.dart';

class TextWidgets extends StatelessWidget {
  final String? texts;
  final Color? color;
  final double? fontSize;
  final FontWeight? weight;
  final TextStyle? style;
  final TextAlign? textAlign;

  const
  TextWidgets(
      {super.key,
      this.texts,
      this.color,
      this.fontSize,
      this.weight,
      this.style,
      this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      texts ?? "",
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: weight,
      ),
      textAlign: textAlign,
    );
  }
}

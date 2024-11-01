import 'package:flutter/material.dart';

class IconWidgets extends StatelessWidget {
  final Icon? icon;
  final double? size;
  final VoidCallback? onPressed;
  final Color? color;



  const IconWidgets(
      {super.key, this.icon, this.size, this.onPressed, this.color,});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon ??  Icon(Icons.settings,color: color),
      iconSize: size,
    );
  }
}

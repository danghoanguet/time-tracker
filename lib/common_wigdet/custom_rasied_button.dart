import 'package:flutter/material.dart';

class CustomRasiedButton extends StatelessWidget {
  CustomRasiedButton({
    this.child,
    this.color,
    this.borderRadius = 8.0,
    this.height: 50,
    this.onPressed,
  });
  final Widget child;
  final Color color;
  final double height;
  final double borderRadius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      // ignore: deprecated_member_use
      child: ElevatedButton(
        child: child,
        style: ElevatedButton.styleFrom( foregroundColor: color, backgroundColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius))),),
        onPressed: onPressed,
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/common_wigdet/custom_rasied_button.dart';

class SignInButton extends CustomRasiedButton {
  SignInButton({
    String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  }) : super(
          child: Text(text,
              style: TextStyle(
                color: textColor,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              )),
          color: color,
          //borderRadius: 10.0,
          onPressed: onPressed,
        );
}

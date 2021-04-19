import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_wigdet/custom_elevated_button.dart';

class SocicalSignInButton extends CustomElevatedButton {
  SocicalSignInButton({
    @required text,
    @required imageURL,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset(imageURL),
                Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Opacity(
                  opacity: 0.0,
                  child: Image.asset(imageURL),
                )
              ]),
          color: color,
          //borderRadius: 10.0,
          onPressed: onPressed,
        );
}

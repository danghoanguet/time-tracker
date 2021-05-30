import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_wigdet/custom_rasied_button.dart';

class FormSubmitButton extends CustomRasiedButton {
  FormSubmitButton({
    @required String text,
    VoidCallback onPressed,
  }) : super(
          child: Text(text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              )),
          color: Colors.indigo,
          height: 44,
          borderRadius: 8.0,
          onPressed: onPressed,
        );
}

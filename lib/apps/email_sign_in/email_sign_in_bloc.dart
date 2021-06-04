import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/apps/email_sign_in/email_sign_in_model.dart';

import 'package:time_tracker_flutter_course/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({
    @required this.auth,
  });

  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();
  final AuthBase auth;

  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel(); // last EmailSignInModel data

  void dispose() {
    _modelController.close();
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);
  void updateFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      // We still need to update email and password to '' because the 59 & 60 line
      // just call the funcion to clear the value text so we cant see it but its still
      // the remain email and password before toogle
      email: '',
      password: '',
      formType: formType,
      isloading: false,
      isSubmitted: false,
    );
  }

  // When ever we call updateWith() method,
  //its will update model + update stream which will rebuild the EmailSignInFormBlocBased by using StreamBuilder in build() method
  void updateWith({
    String email,
    String password,
    bool isSubmitted,
    bool isloading,
    EmailSignInFormType formType,
  }) {
    // update model
    _model = _model.copyWith(
      email: email,
      password: password,
      isSubmitted: isSubmitted,
      isLoading: isloading,
      formType: formType,
    );

    // add updated model to Stream _modelController to setState EmailSignInForm
    _modelController.add(_model);
  }

  Future<void> submit() async {
    updateWith(isloading: true, isSubmitted: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (e) {
      updateWith(isloading: false);
      rethrow;
    }
  }
}

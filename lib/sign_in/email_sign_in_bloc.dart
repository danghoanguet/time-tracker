import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/sign_in/email_sign_in_model.dart';

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
      // String email;
      // if (!_model.email.contains('@')) {
      //   email = _model.email + '@gmail.com';
      // } else {
      //   email = _model.email;
      // }
      // final auth = Provider.of<AuthBase>(context, listen: false);
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

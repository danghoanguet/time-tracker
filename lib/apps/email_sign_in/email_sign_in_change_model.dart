/* These are Stateful variables in SignInWithEmailStateFul

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool isSubmitted = false;
  bool isLoading = false;
*/

// IMPORTANT NOTE: USE BLOC WITH STREAM OF IMMUTEABLE OBJ
// USE CHANGENOTIFIER WITH MUTABLE OBJ

import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/apps/email_sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/apps/email_sign_in/validators.dart';

import 'package:time_tracker_flutter_course/services/auth.dart';

class EmailSignInChangeModel with EmailAndPasswordValidator, ChangeNotifier {
  EmailSignInChangeModel({
    @required this.auth,
    this.email = '',
    this.password = '',
    this.isSubmitted = false,
    this.isLoading = false,
    this.formType = EmailSignInFormType.signIn,
  });

  final AuthBase auth;
  String email;
  String password;
  bool isSubmitted;
  bool isLoading;
  EmailSignInFormType formType;

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void updateFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      // We still need to update email and password to '' because the 59 & 60 line
      // just call the funcion to clear the value text so we cant see it but its still
      // the remain email and password before toogle
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      isSubmitted: false,
    );
  }

  Future<void> submit() async {
    updateWith(isLoading: true, isSubmitted: true);
    try {
      if (this.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(this.email, this.password);
      } else {
        await auth.createUserWithEmailAndPassword(this.email, this.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  bool submitEnable() {
    return this.emailValidator.isValid(this.email) &&
        this.passwordValidator.isValid(this.password) &&
        !this.isLoading;
  }

  String get errorPasswordText {
    bool showError =
        !this.passwordValidator.isValid(this.password) && this.isSubmitted
            ? true
            : false;
    return showError ? passwordInVaildErrorText : null;
  }

  String get errorEmailText {
    bool showError =
        !this.passwordValidator.isValid(this.password) && this.isSubmitted
            ? true
            : false;
    return showError ? emailInVaildErrorText : null;
  }

  bool textButtonEnable() {
    return isLoading ? false : true;
  }

  String get primaryText {
    final primaryText = this.formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    return primaryText;
  }

  String get secondaryText {
    final secondaryText = this.formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
    return secondaryText;
  }

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool isSubmitted,
  }) {
    this.email = email ??
        this.email; // ?? : this will return this.email if email parameter is null
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.isSubmitted = isSubmitted ?? this.isSubmitted;
    notifyListeners();
  }
  // example: copyWith(email: newEmail) => this.email = newEmail, this.password = this.password, etc

}

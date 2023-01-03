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

import 'package:time_tracker_flutter_course/app/email_sign_in/validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidator {
    EmailSignInModel({
    this.email = '',
    this.password = '',
    this.isSubmitted = false,
    this.isLoading = false,
    this.formType = EmailSignInFormType.signIn,
  });

  final String email;
  final String password;
  final bool isSubmitted;
  final bool isLoading;
  final EmailSignInFormType formType;

  bool submitEnable() {
    return this.emailValidator.isValid(this.email) &&
        this.passwordValidator.isValid(this.password) &&
        !this.isLoading;
  }

  /*
    bool showError =
        !model.passwordValidator.isValid(model.password) && model.isSubmitted
            ? true
            : false;

              bool emailValid =
        !model.emailValidator.isValid(model.email) && model.isSubmitted
            ? true
            : false;
  */

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

  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool isSubmitted,
  }) {
    return EmailSignInModel(
      email: email ??
          this.email, // ?? : this will return this.email if email parameter is null
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
  // ex: copyWith(email: newEmail) => this.email = newEmail, this.password = this.password, etc

}

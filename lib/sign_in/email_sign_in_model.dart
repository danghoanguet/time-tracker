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

enum EmailSignInFormType { signIn, register }

class EmailSignInModel {
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

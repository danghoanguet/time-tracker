import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_wigdet/formSubmitButton.dart';
import 'package:time_tracker_flutter_course/common_wigdet/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_wigdet/show_exception_alert_diaglog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/sign_in/validators.dart';

//enum EmailSignInFormType { signIn, register }

class EmailSignInFormBlocBased extends StatefulWidget
    with EmailAndPasswordValidator {
  EmailSignInFormBlocBased({Key key, this.emailSignInBloc});

  final EmailSignInBloc emailSignInBloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
        create: (_) => EmailSignInBloc(auth: auth),
        dispose: (
          _,
          emailSignInBloc,
        ) =>
            emailSignInBloc.dispose(),
        child: Consumer<EmailSignInBloc>(
          builder: (_, emailSignInBloc, __) => EmailSignInFormBlocBased(
            emailSignInBloc: emailSignInBloc,
          ),
        ));
  }

  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _toggleFormStyle(EmailSignInModel model) {
    print('Email: ${model.email}');
    widget.emailSignInBloc.updateWith(
      // We still need to update email and password to '' because the 59 & 60 line
      // just call the funcion to clear the value text so we cant see it but its still
      // the remain email and password before toogle
      email: '',
      password: '',
      formType: model.formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn,
      isloading: false,
      isSubmitted: false,
    );

    _emailController.clear();
    _passwordController.clear();
  }

  void _emailEditingComplete(EmailSignInModel model) {
    FocusNode newFocus = widget.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  Future<void> _submit() async {
    try {
      await widget.emailSignInBloc.submit();
      await showAlertDialog(context,
          title: "Sign In Succes",
          content: "You are going to Home in 3 seconds",
          defaultActionText: "",
          autoDismiss: true);
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'SIGN IN FAIL',
        exception: e,
      );
    }
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    final primaryText = model.formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final secondaryText = model.formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';

    bool submitEnable = widget.emailValidator.isValid(model.email) &&
        widget.passwordValidator.isValid(model.password) &&
        !model.isLoading;
    bool textButtonEnable = !model.isLoading;

    return [
      _buildEmailTextField(model),
      SizedBox(
        height: 15,
      ),
      _buildPasswordTextField(model),
      SizedBox(
        height: 20,
      ),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnable ? _submit : null,
      ),
      SizedBox(
        height: 20,
      ),
      TextButton(
        child: Text(
          secondaryText,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
        onPressed: textButtonEnable ? () => _toggleFormStyle(model) : null,
      ),
    ];
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    bool showError =
        !widget.passwordValidator.isValid(model.password) && model.isSubmitted
            ? true
            : false;
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        errorText: showError ? widget.passwordInVaildErrorText : null,
        enabled: model.isLoading == false ? true : false,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.done,
      obscureText: true,
      onChanged: (password) =>
          widget.emailSignInBloc.updateWith(password: password),
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    bool emailValid =
        !widget.emailValidator.isValid(model.email) && model.isSubmitted
            ? true
            : false;
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        hintText: 'abc@gmail.com',
        errorText: emailValid ? widget.emailInVaildErrorText : null,
        enabled: model.isLoading == false ? true : false,
      ),
      autocorrect: false,
      onChanged: (email) => widget.emailSignInBloc.updateWith(email: email),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingComplete(model),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.emailSignInBloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildChildren(model),
            ),
          );
        });
  }

  // void _updateState(EmailSignInModel model) {
  //   print(
  //       'email: ${model.email} password: ${model.password}, emailIsNotEmpty: ${model.email.isNotEmpty} passwordIsNotEmpty: ${model.password.isNotEmpty}');
  //   widget.emailSignInBloc
  //       .updateWith(email: model.email, password: model.password);
  // }
}

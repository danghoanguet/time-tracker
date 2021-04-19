
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_wigdet/formSubmitButton.dart';
import 'package:time_tracker_flutter_course/common_wigdet/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth_provider.dart';
import 'package:time_tracker_flutter_course/sign_in/validators.dart';


  enum EmailSignInFormType {signIn, register}

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidator {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {



    EmailSignInFormType _formType = EmailSignInFormType.signIn;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool isSubmitted = false;
  bool isLoading = false;


  void _toggleFormStyle() {
    setState(() {
      isSubmitted = false;
        _formType = _formType == EmailSignInFormType.signIn ?
            EmailSignInFormType.register : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  void _submit() async {
    setState(() {
      isSubmitted = true;
      isLoading = true;
    });

    try {
      String email;
      if(!_email.contains('@')) {
         email = _email + '@gmail.com';
      }else {
        email = _email;
      }

      final auth = AuthProvider.of(context);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(
            email, _passwordController.text);
      }
      else {
        await auth.createUserWithEmailAndPassword(
            _emailController.text, _passwordController.text);
      }
      Navigator.of(context).pop();
    }catch (e) {
      showAlertDialog(
          context,
          title: 'SIGN IN FAIL',
          content: e.toString(),
          defaultActionText: 'OK' );
    }finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn ?
         'Sign in' : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn ?
        'Need an account? Register' : 'Have an account? Sign in';

    bool submitEnable = widget.emailValidator.isValid(_email)
        && widget.passwordValidator.isValid(_password) && !isLoading;
    bool textButtonEnable = !isLoading;

    return [
      _buildEmailTextField(),
      SizedBox(
        height: 15,
      ),
      _buildPasswordTextField(),
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.indigo
            ),
          ),
        onPressed:  textButtonEnable ? _toggleFormStyle : null,
      ),


    ];
  }

  TextField _buildPasswordTextField() {
    bool showError = !widget.passwordValidator.isValid(_password) && isSubmitted ? true : false ;
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
        ),
        errorText: showError ?  widget.passwordInVaildErrorText : null,
        enabled: isLoading == false ? true: false,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.done,
      obscureText: true,
      onChanged: (password) => _updateState(),
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField() {
    bool emailValid = !widget.emailValidator.isValid(_email) && isSubmitted ? true : false;
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600
        ),
        hintText: 'abc@gmail.com',
        errorText: emailValid ? widget.emailInVaildErrorText : null,
        enabled: isLoading == false ? true: false,
      ),
      autocorrect: false,
      onChanged: (email) => _updateState(),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }

  void _emailEditingComplete() {
    FocusNode newFocus = widget.emailValidator.isValid(_email) ?
        _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _updateState() {
    print('email: $_email password: $_password, emailIsNotEmpty: ${_email.isNotEmpty} passwordIsNotEmpty: ${_password.isNotEmpty}');
    setState(() {
    });
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/email_sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/app/email_sign_in/email_sign_in_bloc_behavior_subject.dart';
import 'package:time_tracker_flutter_course/common_wigdet/formSubmitButton.dart';
import 'package:time_tracker_flutter_course/common_wigdet/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_wigdet/show_exception_alert_diaglog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'email_sign_in_model.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({Key key, this.emailSignInBloc});

  final EmailSignInBlocBehaviorSubject emailSignInBloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBlocBehaviorSubject>(
        create: (_) => EmailSignInBlocBehaviorSubject(auth: auth),
        dispose: (
          _,
          emailSignInBloc,
        ) =>
            emailSignInBloc.dispose(),
        child: Consumer<EmailSignInBlocBehaviorSubject>(
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

  void _toggleFormStyle() {
    widget.emailSignInBloc.updateFormType();

    _emailController.clear();
    _passwordController.clear();
  }

  void _emailEditingComplete(EmailSignInModel model) {
    FocusNode newFocus = model.emailValidator.isValid(model.email)
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
        text: model.primaryText,
        onPressed: model.submitEnable() ? _submit : null,
      ),
      SizedBox(
        height: 20,
      ),
      TextButton(
        child: Text(
          model.secondaryText,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
        onPressed: model.textButtonEnable() ? _toggleFormStyle : null,
      ),
    ];
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        errorText: model.errorPasswordText,
        enabled: model.isLoading == false ? true : false,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.done,
      obscureText: true,
      onChanged: widget.emailSignInBloc.updatePassword,
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        hintText: 'abc@gmail.com',
        errorText: model.errorEmailText,
        enabled: model.isLoading == false ? true : false,
      ),
      autocorrect: false,
      onChanged: widget.emailSignInBloc.updateEmail,
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
}

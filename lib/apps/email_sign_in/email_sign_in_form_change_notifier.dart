import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/apps/email_sign_in/email_sign_in_change_model.dart';

import 'package:time_tracker_flutter_course/common_wigdet/formSubmitButton.dart';
import 'package:time_tracker_flutter_course/common_wigdet/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_wigdet/show_exception_alert_diaglog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({Key key, this.model});

  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
        create: (_) => EmailSignInChangeModel(auth: auth),
        child: Consumer<EmailSignInChangeModel>(
          // this builder called every time we call notifiyListener tks to ChangeNotifierProvider
          // and the build method will be called to update state
          builder: (_, model, __) => EmailSignInFormChangeNotifier(
            model: model,
          ),
        ));
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model =>
      widget.model; // use model. instead of widget.model

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _toggleFormStyle() {
    model.updateFormType();

    _emailController.clear();
    _passwordController.clear();
  }

  void _emailEditingComplete() {
    FocusNode newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  Future<void> _submit() async {
    try {
      await model.submit();
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

  List<Widget> _buildChildren() {
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

  TextField _buildPasswordTextField() {
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
      onChanged: model.updatePassword,
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField() {
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
      onChanged: model.updateEmail,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingComplete(),
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
}


import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/services/auth_provider.dart';
import 'package:time_tracker_flutter_course/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/sign_in/social_sign_in_button.dart';

class SignInPage extends StatelessWidget {
  Future<void> _signInAnonymously(BuildContext context) async {
    final auth = AuthProvider.of(context);
    try{
     await auth.signInAnonymously();
    }catch (e) {
      print(e.toString());
    }
  }
  Future<void> _signInWithGoogle(BuildContext context) async {
    final auth = AuthProvider.of(context);
    try{
      await auth.signInWithGoogle();
    }catch (e) {
      print(e.toString());
    }
  }

  void _signInWithEmail(BuildContext context) {
    final auth = AuthProvider.of(context);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text("My time tracker"),
        toolbarTextStyle: TextStyle(
            fontSize: 10,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(child: _buildContent(context)),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 100),
          Text(
            'Sign in here',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 40,
                fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 100),
          SocicalSignInButton(
            text: 'Sign in with Google',
            imageURL: 'images/google-logo.png',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed:() => _signInWithGoogle(context),
          ),
          SizedBox(
            height: 10,
          ),
          SocicalSignInButton(
            text: 'Sign in with Facebook',
            imageURL: 'images/facebook-logo.png',
            textColor: Colors.white,
            color: Color(0XFF334D92),
            onPressed: () {},
          ),
          SizedBox(
            height: 10,
          ),
          SignInButton(
            text: 'Sign in with Email',
            color: Colors.teal,
            textColor: Colors.black87,
            onPressed:() => _signInWithEmail(context),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'or',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            height: 20,
          ),
          SignInButton(
            text: 'Go with anonymous ',
            color: Colors.yellowAccent,
            textColor: Colors.black87,
            onPressed:() => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }
}



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/email_sign_in/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_manager.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/common_wigdet/show_exception_alert_diaglog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
//import 'package:time_tracker_flutter_course/sign_in/sign_in_bloc.dart';

class SignInPage extends StatelessWidget {
  const SignInPage(
      {Key key, @required this.signInManager, @required this.isLoading})
      : super(key: key);

  final SignInManager signInManager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        // This Consumer gives SignInBloc Constructor ValueNotifier<bool>
        builder: (_, isLoading, __) => Provider<SignInManager>(
          // this builder call every time the ValueNotifier<bool> change
          // Provide SignInManager to SignInPage
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          // dispose: (_, signInBloc) => signInBloc.dispose(), // use for bloc + StreamBuilder
          child: Consumer<SignInManager>(
              //This Consumer gives SignInPage Constructor SignInManager
              builder: (_, signInManager, __) => SignInPage(
                    signInManager: signInManager,
                    isLoading: isLoading.value,
                  )),
        ),
      ),
    );
  }

  // this is for using bloc + streamBuilder
  // static Widget create(BuildContext context) {
  //   final auth = Provider.of<AuthBase>(context, listen: false);
  //   return Provider<SignInBloc>(
  //     create: (_) => SignInBloc(auth: auth),
  //     dispose: (_, signInBloc) => signInBloc.dispose(),
  //     child: Consumer<SignInBloc>(
  //         builder: (_, signInBloc,__) => SignInPage(signInBloc: signInBloc)),
  //   );
  // }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseAuthException &&
        exception.code == 'ERROR_ABORTED BY USER') {
      return;
    } else {
      showExceptionAlertDialog(context,
          title: "Sign in failed", exception: exception);
    }
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await signInManager.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await signInManager.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await signInManager.signInWithFacebook();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => EmailSignInPage(),
    ));
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
      body: _buildContent(context),
      // This for using bloc + StreamBuilder
      // body: StreamBuilder<bool>(
      //     stream: signInBloc.isLoadingStream,
      //     initialData: false,
      //     builder: (context, snapshoot) {
      //       return SingleChildScrollView(
      //           child: _buildContent(context, snapshoot.data));
      //     }),
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
          SizedBox(
            height: 50,
            child: _buildHeader(),
          ),
          SizedBox(height: 100),
          SocicalSignInButton(
            text: 'Sign in with Google',
            imageURL: 'images/google-logo.png',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(
            height: 10,
          ),
          SocicalSignInButton(
            text: 'Sign in with Facebook',
            imageURL: 'images/facebook-logo.png',
            textColor: Colors.white,
            color: Color(0XFF334D92),
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
          ),
          SizedBox(
            height: 10,
          ),
          SignInButton(
            text: 'Sign in with Email',
            color: Colors.teal,
            textColor: Colors.black87,
            onPressed: isLoading ? null : () => _signInWithEmail(context),
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
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Text(
        'Sign in here',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 40,
            fontWeight: FontWeight.w800),
      );
    }
  }
}

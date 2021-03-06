import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

// this class provider services to SigInPage such as Auth and State
class SignInBloc {
  SignInBloc({
    @required this.auth,
  });

  final AuthBase auth;
  // final ValueNotifier<bool> isLoading;

  //For using bloc + streamBuilder
  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;
  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      //isLoading.value = true;
      _setIsLoading(true);
      return await signInMethod(); // signInMethod is a fuction return Future<User> pass as parameter
    } catch (e) {
      //isLoading.value = false;
      _setIsLoading(
          false); // if sign in fail setIsLoading is false, if sucess move to HomePage
      rethrow;
    }
  }

  Future<User> signInAnonymously() async => _signIn(auth.signInAnonymously);

  Future<User> signInWithFacebook() async => _signIn(auth.signInWithFacebook);

  Future<User> signInWithGoogle() async => _signIn(auth.signInWithGoogle);
}

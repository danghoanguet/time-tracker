import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInBloc {
  final StreamController<bool> _isLoadingController = StreamController<bool>();
  final AuthBase auth;

  SignInBloc({@required this.auth});

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      rethrow;
    } finally {
      _setIsLoading(false);
    }
  }

  Future<User> signInAnonymously() async => _signIn(auth.signInAnonymously);

  Future<User> signInWithFacebook() async => _signIn(auth.signInWithFacebook);

  Future<User> signInWithGoogle() async => _signIn(auth.signInWithGoogle);
}

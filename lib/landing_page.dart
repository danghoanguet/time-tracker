

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/home_page.dart';
import 'package:time_tracker_flutter_course/sign_in/sign_in_page.dart';

import 'services/auth_provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    return StreamBuilder<User> (
      stream: auth.onAuthStateChanges(),
      builder: (context,snapshot) {
        if(snapshot.connectionState == ConnectionState .active) {
          final User user = snapshot.data;
          if (user == null) {
            return SignInPage(
            );
          }
          return HomePage(
          );
        }
        else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            )
          );
        }
      }
    );
  }
}

import 'package:budgettrack/pages/splashscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'loginOrReg.dart';


class AuthPage extends StatelessWidget {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user logged in
          if (snapshot.hasData) {
            return  SplashScreen();
          }
          //user not logged in
          else {

            return LoginOrRegiter();
          }
        },
      ),

    );
  }
}

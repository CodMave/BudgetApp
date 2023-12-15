import 'dart:async';

import 'package:budgettrack/components/button.dart';
import 'package:budgettrack/pages/DemoPage.dart';
import 'package:budgettrack/pages/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';

class EmailVerification extends StatefulWidget {
  late final name;
  late final username;
  late final password;
  late final currency;
   EmailVerification(String name, String username, String password, String currency, {Key? key}) : super(key: key){
    this.name=name;
    this.username=username;
    this.password=password;
    this.currency=currency;
  }

  @override
  State<EmailVerification> createState() => _EmailVerification(
      username:username,
      password:password,
      name:name,
      currency:currency,

  );
}

class _EmailVerification extends State<EmailVerification> {
  void Function()? onTap;
  bool isEmailVerified = false;
  bool canResendEmail = false;
  bool _mounted=true;
  Timer? timer;
  final username;
  final password;
  final name;
  final currency;
  _EmailVerification({required this.username,required this.password, required this.name, required this.currency,});
  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    isEmailVerified = user?.emailVerified ?? false;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
            (_) {
          if (_mounted) { // Check if the widget is still mounted
            checkIsEmailVerified();
          }
          else{
            timer?.cancel();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _mounted = false;
    super.dispose();
  }
  Future<void> checkIsEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      setState(() {
        isEmailVerified = user.emailVerified;
      });

      if (isEmailVerified) {
        try {
          // Check if a document with the same username or email already exists
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('userDetails')
              .where('username', isEqualTo: name)
              .where('email', isEqualTo: username)
              .get();

          if (querySnapshot.docs.isEmpty) {
            // No existing document found, so add a new one
            await FirebaseFirestore.instance.collection('userDetails').add({
              'username': name,
              'email': username,
              'password': password,
              'currency': currency,
            });
          } else {
            // Document with the same username or email already exists
            print('Error: User with the same username or email already exists.');
          }
        } catch (e) {
          // Handle other errors
          print('Error: $e');
        }
      }
    }
  }




  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        canResendEmail = false;
      });

      await Future.delayed(const Duration(seconds: 5));

      setState(() {
        canResendEmail = true;
      });
    } catch (ex) {
      print(ex);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isEmailVerified) {
      return MyApp1();
    }
    else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          elevation: 1,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //icon
                const Icon(
                  Icons.mark_email_read_rounded,
                  size: 150,
                ),

                const SizedBox(height: 30),

                //message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: [
                      Text(
                        "Verify your email address",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "We have just send email verification link to your email. Please check email and click on that link",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "If you haven't recieved the link yet, please click on Resend button",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                //resend button
                MyButton(
                  onTap: canResendEmail ? sendVerificationEmail : null,
                  text: "Resend",
                ),

                const SizedBox(height: 15),

                //cancel button
                //cancel button
                GestureDetector(
                  onTap: () {
                    // Check if there is a current user before signing out
                    if (FirebaseAuth.instance.currentUser != null) {
                      FirebaseAuth.instance.signOut();
                    }

                    // You may also choose to navigate back to the previous screen instead of signing out directly.
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(onTap: onTap),
                      ),
                    );
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.blue[400],
                      fontSize: 16,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      );
    }
  }
}


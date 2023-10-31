import 'dart:async';

import 'package:budgettrack/components/button.dart';
import 'package:budgettrack/pages/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerification();
}

class _EmailVerification extends State<EmailVerification> {
  void Function()? onTap;
  bool isEmailVerified = false;
  bool canResendEmail = false;
  bool _mounted=true;
  Timer? timer;

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

  Future checkIsEmailVerified() async {
    // Check if there is a current user
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Reload the user to get the latest email verification status
      await user.reload();

      setState(() {
        isEmailVerified = user.emailVerified;
      });
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
      return LoginPage(onTap: onTap);
    }
    else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          elevation: 1,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.grey[300],
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


import 'dart:async';

import 'package:budgettrack/components/button.dart';

import 'package:budgettrack/pages/homePage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerification();
}

class _EmailVerification extends State<EmailVerification> {
  void Function()? onTap;
  bool isEmailVerified = false;
  bool canResendEmail = false;
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
        (_) => checkIsEmailVerified(),
      );
    } else {
      //navigate to home page
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkIsEmailVerified() async {
    // call after mail verification
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      //navigate to home page
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        canResendEmail = false;
      });

      await Future.delayed(Duration(seconds: 5));

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
      return HomePage();
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          elevation: 1,
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
                GestureDetector(
                  onTap: () => FirebaseAuth.instance.signOut(),
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

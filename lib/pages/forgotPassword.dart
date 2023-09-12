import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/button.dart';
import '../components/textfield.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final usernameControll = TextEditingController();

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: usernameControll.text);
      userAlert("Link sent! Please check your Email");
    } on FirebaseAuthException catch (ex) {
      print(ex);
      userAlert("User not found!");
    }
  }

  void userAlert(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.white),
          ),
          backgroundColor: Colors.grey[800],
          title: Text(
            message,
            style: TextStyle(
              color: Colors.grey[400],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
      ),
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                      alignment: Alignment.topCenter,
                      width:150,
                      height:150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('lib/images/monkey.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      )),
                ],
              ),
              const SizedBox(height: 20),

              // Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  "Enter the Email associated with your account and we will send you a reset link",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 18,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // email field

              MyTextField(
                controller: usernameControll,
                hintText: 'Email',
                obsecureText: false,
              ),

              const SizedBox(height: 30),

              // button

              MyButton(
                onTap: passwordReset,
                text: "Continue",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

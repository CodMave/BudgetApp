import 'package:budgettrack/components/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../components/button.dart';
import '../components/tile.dart';
import '../services/authService.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  //text editing
  final usernameControll = TextEditingController();

  final passwordControll = TextEditingController();

  final confirmPasswordControll = TextEditingController();

  //user signup method
  void userSignUp() async {
    //loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //sign up
    try {
      if (passwordControll.text == confirmPasswordControll.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usernameControll.text,
          password: passwordControll.text,
        );
      } else {
        // error
        wrongInputlAlert();
      }
    } on FirebaseAuthException catch (ex) {
      if (mounted) {
        Navigator.pop(context);
      }
      // wrong mail
      if (ex.code == 'user-not-found') {
        wrongInputlAlert();
      }
      //wrong password
      else if (ex.code == 'wrong-password') {
        wrongInputlAlert();
      }
    }

    //loading circle end
    if (mounted) {
      Navigator.pop(context);
    }
  }

  //Wrong mail or password

  void wrongInputlAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.white),
          ),
          backgroundColor: Colors.grey[700],
          title: Text(
            "Incorrect Creditentials",
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 20),
            //logo
            const Icon(
              Icons.lock,
              size: 50,
            ),

            const SizedBox(height: 20),

            //welcome text

            Text(
              'Register Now',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 24,
              ),
            ),

            const SizedBox(height: 40),

            //username

            MyTextField(
              controller: usernameControll,
              hintText: 'Email',
              obsecureText: false,
            ),

            const SizedBox(height: 15),

            //new password

            MyTextField(
              controller: passwordControll,
              hintText: 'New Password',
              obsecureText: true,
            ),

            const SizedBox(height: 15),

            //confirm password

            MyTextField(
              controller: confirmPasswordControll,
              hintText: 'Confirm Password',
              obsecureText: true,
            ),

            const SizedBox(height: 30),

            //sign in

            MyButton(
              onTap: userSignUp,
              text: "Sign Up",
            ),

            const SizedBox(height: 30),

            //continue with

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Or Continue With",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            //google and apple logo

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //google

                MyTitle(
                  imagePath: 'lib/images/google.png',
                  onTap: () => AuthService().signInWithGoodle(),
                ),

                const SizedBox(width: 25),
                //apple

                MyTitle(
                  imagePath: 'lib/images/apple.png',
                  onTap: () => {},
                ),
              ],
            ),

            const SizedBox(height: 25),

            //sign up

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "  Login Now",
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

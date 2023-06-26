import 'package:budgettrack/components/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../components/button.dart';
import '../components/title.dart';

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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameControll.text,
        password: passwordControll.text,
      );
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
        return const AlertDialog(
          title: Text("Incorrect Creditentials"),
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
            const SizedBox(height: 5),
            //logo
            const Icon(
              Icons.lock,
              size: 100,
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

            const SizedBox(height: 20),

            //username

            MyTextField(
              controller: usernameControll,
              hintText: 'Email',
              obsecureText: false,
            ),

            const SizedBox(height: 10),

            //new password

            MyTextField(
              controller: passwordControll,
              hintText: 'New Password',
              obsecureText: true,
            ),

            const SizedBox(height: 10),

            //confirm password

            MyTextField(
              controller: passwordControll,
              hintText: 'Confirm Password',
              obsecureText: true,
            ),

            const SizedBox(height: 10),

            //forgot password

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Forgot Password ?',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //sign in

            MyButton(
              onTap: userSignUp,
            ),

            const SizedBox(height: 15),

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

            const SizedBox(height: 15),

            //google and apple logo

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //google

                MyTitle(imagePath: 'lib/images/google.png'),

                const SizedBox(width: 25),
                //apple

                MyTitle(imagePath: 'lib/images/apple.png'),
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

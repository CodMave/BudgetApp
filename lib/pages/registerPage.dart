import 'package:budgettrack/components/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/button.dart';
import '../pages/emailVerification.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  //text editing
  final usernameControll = TextEditingController();

  final passwordControll = TextEditingController();

  final confirmPasswordControll = TextEditingController();

  final emailControll = TextEditingController();

  //selectedCurrency;

  String? selectedCurrency = "USD";
  List currency = [
    'USD',
    'EUR',
    'INR',
    'SLR',
    'GBP',
    'AUD',
    'CAD'
    // ADD MORE
  ];

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
          email: emailControll.text,
          password: passwordControll.text,
        );

        //save user details in firestore
        saveUserDetails(
          usernameControll.text.trim(),
          emailControll.text.trim(),
          passwordControll.text.trim(),
          selectedCurrency!,
        );

        //navigate to email verification page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const EmailVerification(),
          ),
        );
      } else {
        // error
        wrongInputlAlert("Passwords don't match");
      }
      //Navigator.pop(context);
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);
      // wrong mail
      wrongInputlAlert(ex.code);
    }

    //loading circle end
    if (mounted) {
      Navigator.pop(context);
    }
  }

  //Wrong mail or password

  void wrongInputlAlert(String message) {
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
            message,
            style: TextStyle(
              color: Colors.grey[400],
            ),
          ),
        );
      },
    );
  }

  //save user details in firestore [database : userDetails]

  Future saveUserDetails(
      String name, String email, String password, String currency) async {
    await FirebaseFirestore.instance.collection('userDetails').add({
      'username': name,
      'email': email,
      'password': password,
      'currency': currency,
    });
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
              hintText: 'Name',
              obsecureText: false,
            ),

            const SizedBox(height: 15),

            //email

            MyTextField(
              controller: emailControll,
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

            const SizedBox(height: 15),

            //currency selection

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: DropdownButtonFormField(
                value: selectedCurrency,
                items: currency.map((listValue) {
                  return DropdownMenuItem(
                    value: listValue,
                    child: Text(listValue),
                  );
                }).toList(),
                onChanged: (valueSelected) {
                  setState(() {
                    selectedCurrency = valueSelected as String;
                  });
                },
                icon: Icon(
                  Icons.arrow_downward_outlined,
                  color: Colors.grey[800],
                ),
                dropdownColor: Colors.grey[200],
                decoration: InputDecoration(
                  labelText: "Selet The Currency",
                  labelStyle: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                  prefixIcon: Icon(
                    Icons.attach_money_sharp,
                    color: Colors.grey[700],
                    size: 40,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            //register button

            MyButton(
              onTap: () {
                userSignUp();
              },
              text: "Register",
            ),

            const SizedBox(height: 25),

            //signup

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

import 'dart:convert';

import 'package:budgettrack/components/textfield.dart';
import 'package:budgettrack/pages/homePage.dart';
import 'package:budgettrack/pages/splashscreen.dart';
import 'package:budgettrack/services/authService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../components/button.dart';
import '../components/tile.dart';
import 'forgotPassword.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //text editing
  final usernameControll = TextEditingController();
  String mtoken='';
  final formKey = GlobalKey<FormState>();
  final passwordControll = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
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

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  void setvalidity()async{
    User? user = _auth.currentUser;
    String username = user!.uid;
    final existingEntry = await getExistingEntry('valid');

    if (existingEntry != null) {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final DocumentReference documentReference = firestore
          .collection('userDetails')
          .doc(username)
          .collection('Tokens')
          .doc(existingEntry);

      // Use the update method to update the "Balance" field
      await documentReference.update({
        'State': 'invalid',
      });
    }
  }


  Future<String?> getExistingEntry(String state) async {
    User? user = _auth.currentUser;
    String username = user!.uid;
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final QuerySnapshot querySnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('Tokens')
          .where('State', isEqualTo: state)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Return the document ID of the existing entry
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (ex) {
      print('Error getting existing entry: $ex');
      return null;
    }
  }
  void userSignIn() async {
    if (usernameControll.text.isEmpty || passwordControll.text.isEmpty) {
      wrongInputlAlert('Username or password can\'t empty');
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Sign in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameControll.text,
        password: passwordControll.text,
      );

      // Sign-in successful
      if (mounted) {
        setvalidity();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SplashScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (ex) {
      // Handle sign-in errors
      if (ex.code == 'user-not-found' || ex.code == 'wrong-password') {
        wrongInputlAlert('Invalid username or password');
      } else {
        wrongInputlAlert('Invalid username');
      }
    }
  }


  //Wrong mail or password

  void wrongInputlAlert(String error) {
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
           error,
            style: TextStyle(
              color:  const Color(0xFF090950),
            ),
          ),
        );
      },
    );
  }

  void saveUserDetails(String?currency) async {//this method stores the data of the user who sign in with google account

    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    List<String>? nameParts = user?.displayName?.split(' ');
    await FirebaseFirestore.instance.collection('userDetails').add({
      'username':nameParts?.first,
      'email':user?.email,
      'currency': currency,
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 50),
            Column(
              children: [
                Container(
                    alignment: Alignment.topCenter,
                    width:180,
                    height:180,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/images/Logo.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    )),
              ],
            ),


            const SizedBox(height: 40),

            //welcome text

            Text(
              'Welcome Back',
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

            const SizedBox(height: 20),

            //password

            MyTextField(
              controller: passwordControll,
              hintText: 'Password',
              obsecureText: true,
            ),

            const SizedBox(height: 10),

            //forgot password

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPassword(),
                      ),
                    ),
                    child: Text(
                      'Forgot Password ?',
                      style: TextStyle(
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            //sign in

            MyButton(
              onTap: userSignIn,
              text: "Sign In",
            ),

            const SizedBox(height: 18),

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
                      style: TextStyle(color: Colors.grey[700]
                      ),
                      textAlign: TextAlign.center,
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

            const SizedBox(height: 18),

            //google and apple logo

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //google

                MyTitle(
                  imagePath: 'lib/images/google.png',
                  onTap: () async {
                    // Sign in with Google
                    selectedCurrency = await showDialog<String>(//get the currency from the user
                      context: context,
                      builder: (context) {

                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.white),
                          ),
                          backgroundColor: Colors.white,
                          title: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: StatefulBuilder(
                              builder: (context, setState) {
                                return DropdownButtonFormField(
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
                                    labelText: "Select The Currency",
                                    labelStyle: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.attach_money_sharp,
                                      color: Colors.grey[700],
                                      size: 40,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(selectedCurrency);
                              },
                              child: Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                    final googleSignInResult = await AuthService().signInWithGoogle();

                    if (googleSignInResult != null) {
                      // Check if the user details are already saved

                      saveUserDetails(selectedCurrency);
                    }
                  },
                ),


                const SizedBox(width: 25),

              ],
            ),

            const SizedBox(height: 18),

            //sign up

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "haven't got an account?",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "  Register Now",
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

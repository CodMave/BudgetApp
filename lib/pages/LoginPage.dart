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
      wrongInputlAlert();
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

    //sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameControll.text,
        password: passwordControll.text,
      );
    } on FirebaseAuthException catch (ex) {


      // wrong mail
      if (ex.code == 'user-not-found') {
        wrongInputlAlert();
        return;
      }
      //wrong password
      else if (ex.code == 'wrong-password') {
        wrongInputlAlert();
        return ;
      }
    }

    //loading circle end
    if (mounted) {
      setvalidity();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreen(),
        ),
      );
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
              color: Colors.grey[300],
            ),
          ),
        );
      },
    );
  }

  void saveUserDetails(String?currency) async {
    print('works');
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    await FirebaseFirestore.instance.collection('userDetails').add({
      'username':user?.displayName,
      'email':user?.email,
      'currency': currency,
    }
    );
  }
  Future<String>getUser() async {
    //get the username from Profile file
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot qs = await FirebaseFirestore.instance
          .collection('userDetails')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get(); //need to filter the current user's name by matching with the users male at the authentication and the username

      if (qs.docs.isNotEmpty) {
        // Return the document ID of the existing entry
        return qs.docs.first.id;
      } else {
        return '';
      }
      // Handle the case when no matching documents are found for the current user
      print('No matching document found for the current user.');
      return ''; // Return an empty string or null based on your requirements
    } else {
      // Handle the case when the user is not authenticated
      print('User not authenticated.');
      return ''; // Return an empty string or null based on your requirements
    }
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
                  image: AssetImage('lib/images/monkey.png'),
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
                    final googleSignInResult = await AuthService().signInWithGoogle();

                    if (googleSignInResult != null) {
                      // Check if the user details are already saved
                      if (getUser() == null) {
                        final selectedCurrency = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            String selectedCurrency = 'USD'; // Default currency
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(color: Colors.white),
                              ),
                              backgroundColor: Colors.grey[700],
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

                        if (selectedCurrency != null) {
                          // Save user details with selectedCurrency
                          saveUserDetails(selectedCurrency);
                        }
                      } else {
                        // User details already exist, handle navigation or other logic
                        // For example:
                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                      }
                    }
                  },
                ),


                const SizedBox(width: 25),
                //apple

                MyTitle(
                  imagePath: 'lib/images/apple.png',
                  onTap: () => {},
                ),
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

import 'package:budgettrack/pages/splashscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'loginOrReg.dart';


class AuthPage extends StatelessWidget {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  const AuthPage({super.key});

  static Future<String> getUserName() async {
    //get the username of the current user and display it as text
    User? user = _auth.currentUser;
    String email = user!.email!;
    if (user != null) {
      //the query check wither the authentication email match with the email which is taken at the user details
      QuerySnapshot qs = await FirebaseFirestore.instance
          .collection('userDetails')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (qs.docs.isNotEmpty) {
        // Loop through the documents to find the one with the matching email
        for (QueryDocumentSnapshot doc in qs.docs) {
          if (doc.get('email') == email) {
            // Get the 'username' field from the matching document
            String username = doc.get('username');
            print(username);
            return username; //return the user name
          }
        }
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
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          print('there is snapdata ${snapshot.hasData}');
          if (snapshot.hasData) {
            return FutureBuilder<String>(
              future: getUserName(),
              builder: (context, usernameSnapshot) {
                if (usernameSnapshot.connectionState == ConnectionState.done) {
                  String username = usernameSnapshot.data ?? '';

                  if (username.isNotEmpty) {
                    return SplashScreen();
                  } else {
                    return LoginOrRegiter();
                  }
                } else {
                  // Loading state
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            return LoginOrRegiter();
          }
        },
      ),
    );
  }
}

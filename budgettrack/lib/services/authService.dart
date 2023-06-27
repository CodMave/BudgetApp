//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // google sign in
  signInWithGoodle() async {
    //begin sign in process page
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //obtain auth deatails
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    //create a new user
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //finall sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

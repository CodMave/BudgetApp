
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


  class AuthService {
 Future<User?> signInWithGoogle() async {
  try {
  // Begin sign-in process
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain authentication details
  final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

  // Create a new user credential
  final AuthCredential credential = GoogleAuthProvider.credential(
  accessToken: googleAuth.accessToken,
  idToken: googleAuth.idToken,
  );

  // Finally, sign in with the credential
  final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);

  // Extract user information
  final User? user = authResult.user;
  if (user != null) {
  // Username and email are available
  final String username = user.displayName ?? "No Display Name";
  final String email = user.email ?? "No Email";

  print('Username: $username');
  print('Email: $email');

  }

  return user;
  } catch (error) {
  print('Error signing in with Google: $error');
  return null;
  }
  }
  }



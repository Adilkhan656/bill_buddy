// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   // Get current user (to check if already logged in)
//   User? get currentUser => _auth.currentUser;

//   // Stream to listen to login/logout changes
//   Stream<User?> get authStateChanges => _auth.authStateChanges();

//   // 1. Sign In with Google
//   Future<User?> signInWithGoogle() async {
//     try {
//       // Trigger the authentication flow
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) return null; // User cancelled

//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//       // Create a new credential
//       final OAuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Sign in to Firebase with the Google Credential
//       final UserCredential userCredential = await _auth.signInWithCredential(credential);
//       return userCredential.user;
//     } catch (e) {
//       print("Error signing in with Google: $e");
//       return null;
//     }
//   }

//   // 2. Sign In with Email/Password
//   Future<User?> signInWithEmail(String email, String password) async {
//     try {
//       final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user;
//     } catch (e) {
//       print("Error signing in with Email: $e");
//       rethrow; // Pass error to UI to show "Wrong password"
//     }
//   }

//   // 3. Sign Up with Email/Password
//   Future<User?> signUpWithEmail(String email, String password) async {
//     try {
//       final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user;
//     } catch (e) {
//       print("Error signing up: $e");
//       rethrow;
//     }
//   }

//   // 4. Sign Out
//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//     await _auth.signOut();
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:drift/drift.dart' as drift; 
import '../local/database.dart'; // ✅ Import your database

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // 1. SIGN IN WITH GOOGLE (Updated)
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      // ✅ FIX: Save Google User details to Local Database immediately
      if (user != null) {
        await database.saveUserProfile(
          UserProfilesCompanion(
            uid: drift.Value(user.uid),
            name: drift.Value(user.displayName ?? "User"), // Get Name from Google
            email: drift.Value(user.email ?? ""),
            age: const drift.Value(0), // Default age 0 for Google users
          )
        );
      }

      return user;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  // 2. Email Login
  Future<User?> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  // 3. Sign Up
  Future<User?> signUpWithEmail(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  // 4. Sign Out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
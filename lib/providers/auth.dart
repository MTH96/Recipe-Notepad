import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meals/models/database.dart';

class Auth with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _database = MyDatabase();

  bool get isSignIn => _auth.currentUser != null;
  String get userId => isSignIn ? _auth.currentUser.uid : null;
  String get name => isSignIn ? _auth.currentUser.displayName : null;
  String get email => isSignIn ? _auth.currentUser.email : null;
  Uri get photoUrl => isSignIn ? Uri.parse(_auth.currentUser.photoURL) : null;
  String get userToken {
    String token;
    isSignIn
        ? _auth.currentUser.getIdToken().then((value) => token = value)
        : token = null;
    return token;
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await _auth.signInWithCredential(credential);

    await _database.addItem('users/usersInfo', {
      'userId': userId,
      'userName': name,
      'userPhoto': photoUrl.toString(),
      'userEmail': email,
    });

    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  // Future<void> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final AccessToken result = await FacebookAuth.instance.login();

  //   // Create a credential from the access token
  //   final facebookAuthCredential =
  //       FacebookAuthProvider.credential(result.token);

  //   // Once signed in, return the UserCredential
  //   final userCredential = await FirebaseAuth.instance
  //       .signInWithCredential(facebookAuthCredential);

  //   _getUserData(userCredential.user);
  //   notifyListeners();
  // }

  // Future<void> signup(
  //     {@required String email, @required String password}) async {
  //   print('called');
  //   try {
  //     print('called $email  $password');
  //     final userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     print('created');
  //     print(userCredential);

  //     _getUserData(_auth.currentUser);
  //     notifyListeners();
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       print('The password provided is too weak.');
  //     } else if (e.code == 'email-already-in-use') {
  //       print('The account already exists for that email.');
  //     }
  //   } catch (e) {
  //     print('ended');
  //     print(e);
  //   }
  // }

  // Future<void> signin(
  //     {@required String email, @required String password}) async {
  //   try {
  //     final userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     _getUserData(_auth.currentUser);
  //     notifyListeners();
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       print('No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       print('Wrong password provided for that user.');
  //     }
  //   }
  // }

}

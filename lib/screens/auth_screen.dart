import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../providers/settings.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/admin.directory.customer.readonly',
  ],
);

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;

  Map<String, String> langMap;
  Map<String, dynamic> _isEng = {'text': 'eng', 'value': true};
  Future<void> signInWithGoogle() async {
    final _auth = FirebaseAuth.instance;

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);

      Map<String, dynamic> userData = {
        'userId': _auth.currentUser.uid,
        'userName': _auth.currentUser.displayName,
        'userPhoto': _auth.currentUser.photoURL,
        'userEmail': _auth.currentUser.email,
      };
      // Once signed in, return the UserCredential
      await FirebaseFirestore.instance
          .collection('userInfo')
          .doc(_auth.currentUser.uid)
          .set(
            userData,
          );
    } catch (e) {
      print("error: ${e.toString()}");
      throw e;
    }
  }

  void _submitData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await signInWithGoogle();
      Navigator.of(context).pushReplacementNamed('/');
    } catch (error) {
      print("error: ${error.toString()}");
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(langMap['error']),
          content: Text(langMap['errMsg']),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(), child: Text('OK'))
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final langSettings = Provider.of<LanguageSettings>(context);
    langMap = langSettings.getWords(AuthScreen.routeName);
    _isEng['value'] = langSettings.isEng;
    _isEng['text'] = langSettings.isEng ? 'eng' : 'ara';

    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.pink,
                  Colors.purple,
                ],
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.center,
                    child: Stack(alignment: Alignment.center, children: [
                      Image.asset(
                        'Assets/images/app logo.jpeg',
                        width: 300,
                      ),
                      Positioned(
                        bottom: 50,
                        child: Column(
                          children: [
                            Text(
                              langMap['welcome 1'],
                              textDirection: _isEng['value']
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(
                                  fontFamily: 'ArefRuqaa',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              langMap['welcome 2'],
                              textDirection: _isEng['value']
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(
                                  fontFamily: 'ArefRuqaa',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                        onPressed: _submitData,
                        icon: Image.asset(
                          'Assets/images/google.jpg',
                          width: 50,
                        ),
                        label: buttonTitle()),
                  ),
                )
              ],
            ),
          ),
          Positioned(top: 30, right: 20, child: buildDropdownButton()),
        ],
      ),
    );
  }

  Widget buttonTitle() {
    return _isLoading
        ? Padding(
            child: CircularProgressIndicator(
              color: Theme.of(context).accentColor,
              backgroundColor: Colors.white,
            ),
            padding: const EdgeInsets.all(10),
          )
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              langMap['sign in command'],
              textAlign: _isEng['value'] ? TextAlign.left : TextAlign.right,
            ),
          );
  }

  DropdownButton buildDropdownButton() => DropdownButton(
        style: TextStyle(color: Colors.white70),
        dropdownColor: Colors.pink,
        icon: Icon(Icons.language, color: Colors.white70),
        value: _isEng['text'],
        onChanged: (value) {
          setState(() {
            _isEng['text'] = value;
            _isEng['value'] = value == 'eng' ? true : false;
          });
          Provider.of<LanguageSettings>(context, listen: false)
              .setIsEng(_isEng['value']);
        },
        items: [
          DropdownMenuItem(
            child: Text('Ara.'),
            value: 'ara',
          ),
          DropdownMenuItem(
            child: Text('Eng.'),
            value: 'eng',
          ),
        ],
      );
}

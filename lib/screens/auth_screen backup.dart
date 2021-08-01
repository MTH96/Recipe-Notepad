import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings.dart';
// import '../providers/auth.dart';

enum Mode { signIn, signUp }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _heightAnimation;
  Mode _mode = Mode.signIn;
  final _form = GlobalKey<FormState>();
  final _passController = TextEditingController();
  bool _isLoading = false;
  bool _showPassword = true;
  Map<String, String> _userData = {'e-mail': '', 'passsword': ''};
  Map<String, String> langMap;
  Map<String, dynamic> _isEng = {'text': 'eng', 'value': true};

  bool get _isSignInMode => (_mode == Mode.signIn);

  void _switchMode() {
    if (_mode == Mode.signIn)
      setState(() {
        _mode = Mode.signUp;
        _controller.forward();
      });
    else {
      setState(() {
        _mode = Mode.signIn;
      });
      _controller.reverse();
    }
  }

  void _submitData(bool isSignInMode) async {
    print(isSignInMode);
    // if (!_form.currentState.validate()) return;
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    print(isSignInMode);
    if (isSignInMode) {
      print('sign in');
      // await Provider.of<Auth>(context, listen: false).signin(
      // email: _userData['e-mail'],
      // password: _userData['password'],
      // );
    } else {
      // await Provider.of<Auth>(context, listen: false).signup(
      //   email: _userData['e-mail'],
      //   password: _userData['password'],
      // );
    }
    setState(() {
      _isLoading = false;
    });
  }

  String _emailValidator(String text) {
    if (text.isEmpty || !text.contains('@')) return langMap['email error'];

    return null;
  }

  String _passwordValidator(String text) {
    if (text.isEmpty) return langMap['empty password'];
    if (text.length < 8) return langMap['short password'];
    return null;
  }

  String _confirmPasswordValidator(String text) {
    if (_isSignInMode) return null;
    if (text != _passController.text) return langMap['confirm error'];
    ;
    return null;
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _heightAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    _heightAnimation.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final langSettings = Provider.of<LanguageSettings>(context);
    langMap = langSettings.getWords(AuthScreen.routeName);

    return Scaffold(
      body: Stack(children: [
        Container(
          padding: EdgeInsets.all(10),
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
        ),
        Container(
          width: deviceSize.width,
          height: deviceSize.height,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.pink,
                        Colors.purple,
                      ],
                    ),
                  ),
                  transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                  height: 100,
                  width: deviceSize.width * .8,
                  alignment: Alignment.center,
                  child: Text(
                    _isSignInMode
                        ? langMap['sign in text']
                        : langMap['sign up text'],
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ),
                ),
                Form(
                  key: _form,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    constraints:
                        BoxConstraints(maxHeight: _isSignInMode ? 350 : 390),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    width: deviceSize.width * .85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(.8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(langMap['enter your data']),
                        buildTextFormField(
                          hint: langMap['sign email'],
                          userData: _userData,
                          validator: _emailValidator,
                        ),
                        buildTextFormField(
                          hint: langMap['sign password'],
                          userData: _userData,
                          validator: _passwordValidator,
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                          constraints:
                              BoxConstraints(maxHeight: _isSignInMode ? 0 : 70),
                          child: FadeTransition(
                            opacity: _heightAnimation,
                            child: buildTextFormField(
                              hint: langMap['sign confirm'],
                              userData: _userData,
                              validator: _confirmPasswordValidator,
                            ),
                          ),
                        ),
                        CheckboxListTile(
                            title: Text(langMap['show password command']),
                            value: _showPassword,
                            onChanged: (value) => setState(() {
                                  _showPassword = value;
                                })),
                        TextButton(
                            onPressed: _switchMode,
                            child: Text(_isSignInMode
                                ? langMap['sign up switch command']
                                : langMap['sign in switch command'])),
                        ElevatedButton(
                            onPressed: () => _submitData(_isSignInMode),
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  )
                                : Text(
                                    _isSignInMode
                                        ? langMap['sign in command']
                                        : langMap['sign up command'],
                                    textAlign: TextAlign.center,
                                  ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(right: 5, top: 5, child: buildDropdownButton()),
      ]),
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

  TextFormField buildTextFormField({
    @required String hint,
    @required Function validator,
    @required Map<String, String> userData,
  }) {
    return TextFormField(
      controller: hint == langMap['sign password'] ? _passController : null,
      keyboardType: hint == langMap['sign email']
          ? TextInputType.emailAddress
          : TextInputType.visiblePassword,
      obscureText: hint != langMap['sign email'] ? !_showPassword : false,
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: hint,
      ),
      validator: validator,
      onSaved: hint != langMap['sign confirm']
          ? (text) => userData[hint] = text
          : null,
    );
  }
}

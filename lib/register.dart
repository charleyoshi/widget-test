import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:widget_test/main.dart';
import 'package:widget_test/verify.dart';
import './login.dart';

// Problem: when press back and back to this page, it clash.
// Solve:  Before building this page, check user authentication
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  late String _email, _password, _displayName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => {Navigator.pop(context)},
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Form(
                        key: _formKey,
                        child: Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(children: [
                                  Text('Create Account',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text('Sign up now, it\'s free.',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.grey)),
                                ]),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 12),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Email Address',
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (val) => (val!.isEmpty) ||
                                                  (!val.contains("@"))
                                              ? "* Enter a valid email"
                                              : null,
                                          onSaved: (value) => _email = value!,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 12),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Password',
                                            border: OutlineInputBorder(),
                                          ),
                                          obscureText: true,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "* Required";
                                            } else if (value.length < 6) {
                                              return "Password must be at least 6 characters long";
                                            } else
                                              return null;
                                          },
                                          onSaved: (value) =>
                                              _password = value!,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 12),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Display Name',
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "* Required";
                                            } else
                                              return null;
                                          },
                                          onSaved: (value) =>
                                              _displayName = value!,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            style:
                                                TextStyle(color: Colors.grey),
                                            text:
                                                'By clicking Sign Up, you agree to our '),
                                        TextSpan(
                                            text: 'Terms of Service',
                                            style:
                                                TextStyle(color: Colors.blue),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                print('Terms of Service"');
                                              }),
                                        TextSpan(
                                            style:
                                                TextStyle(color: Colors.grey),
                                            text:
                                                ' and that you have read our '),
                                        TextSpan(
                                            text: 'Privacy Policy',
                                            style:
                                                TextStyle(color: Colors.blue),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                print('Privacy Policy"');
                                              }),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 40),
                                    child: Container(
                                      padding: EdgeInsets.only(top: 3, left: 3),
                                      child: MaterialButton(
                                          minWidth: double.infinity,
                                          height: 60,
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              print("Register - Validated");
                                              createAccount();
                                            } else {
                                              print("Register - Not Validated");
                                            }
                                          },
                                          color: Color(0xff0095FF),
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Text('Register',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                  color: Colors.white))),
                                    )),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                style: TextStyle(
                                                    color: Colors.grey),
                                                text:
                                                    'Already have an account? '),
                                            TextSpan(
                                                text: 'Log in',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        LoginPage()));
                                                      }),
                                          ],
                                        ),
                                      ),
                                    ]),
                                Container(
                                    padding: EdgeInsets.only(top: 100),
                                    height: 20,
                                    decoration: BoxDecoration()),
                              ]),
                        ),
                      )
                    ])),
          ],
        ),
      ),
    );
  }

  Future<void> createAccount() async {
    final formState = _formKey.currentState;
    final auth = FirebaseAuth.instance;
    if (formState!.validate()) {
      formState.save();
      try {
        auth
            .createUserWithEmailAndPassword(email: _email, password: _password)
            .then((user) {
          FirebaseAuth.instance.currentUser!.updateDisplayName(_displayName);
        }).then((_) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => VerifyScreen()));
        });
        //TODO: Nagigate to home
      } catch (e) {
        print('e:');
        print(e.toString());
      }
    }
  }
}

bool validateStructure(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}
    // Vignesh123! : true
    // vignesh123 : false
    // VIGNESH123! : false
    // vignesh@ : false
    // 12345678? : false
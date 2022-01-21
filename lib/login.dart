import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import './register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './globals.dart' as globals;
import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String _email, _password;

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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(children: [
                                    Text('Login',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text('Log in to your account.',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.grey)),
                                  ]),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 40),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 16),
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Email Address',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "* Required";
                                              } else
                                                return null;
                                            },
                                            onSaved: (value) => _email = value!,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 16),
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Password',
                                              border: OutlineInputBorder(),
                                            ),
                                            obscureText: true,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "* Required";
                                              } else
                                                return null;
                                            },
                                            onSaved: (value) =>
                                                _password = value!,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 40),
                                      child: Container(
                                        padding:
                                            EdgeInsets.only(top: 3, left: 3),
                                        child: MaterialButton(
                                            minWidth: double.infinity,
                                            height: 60,
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                print("Validated");
                                                signIn();
                                              } else {
                                                print("Not Validated");
                                              }
                                            },
                                            color: Color(0xff0095FF),
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Text('Login',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    color: Colors.white))),
                                      )),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                  text:
                                                      'Don\'t have an account? '),
                                              TextSpan(
                                                  text: 'Create Account',
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
                                                                          RegisterPage()));
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
                          ))
                    ])),
          ],
        ),
      ),
    );
  }

  Future<void> signIn() async {
    //TODO: validate fields
    final formState = _formKey.currentState;

    if (formState!.validate()) {
      formState.save();
      try {
        User? user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: _email, password: _password))
            .user;
        //TODO: Nagigate to home

        print(user);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      } catch (e) {
        print('e:');
        print(e.toString());

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Email or password incorrect :('),
          duration: Duration(seconds: 3),
          // action: SnackBarAction(
          //   label: 'ACTION',
          //   onPressed: () {},
          // ),
        ));
      }
    }
  }
}

// Widget inputFile({label, obscureText = false}) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(label,
//           style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w400,
//               color: Colors.black87)),
//       SizedBox(
//         height: 5,
//       ),
//       TextField(
//         obscureText: obscureText,
//         decoration: InputDecoration(
//             contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//             enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.grey),
//             ),
//             border:
//                 OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
//       ),
//       SizedBox(height: 10),
//     ],
//   );
// }

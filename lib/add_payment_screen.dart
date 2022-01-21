import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import './register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './globals.dart' as globals;
import 'main.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({Key? key}) : super(key: key);

  @override
  _AddPaymentScreenState createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
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
                                  Text('Add Payment Method',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text('Powered by Stripe',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.grey)),
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
}

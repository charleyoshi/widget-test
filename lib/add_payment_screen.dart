import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
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
              margin: EdgeInsets.only(top: 100),
              child: Column(
                children: [
                  CardField(
                    onCardChanged: (card) {
                      print(card);
                    },
                  ),
                  TextButton(
                    onPressed: () async {
                      // create payment method
                      final paymentMethod = await Stripe.instance
                          .createPaymentMethod(PaymentMethodParams.card());
                    },
                    child: Text('pay'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

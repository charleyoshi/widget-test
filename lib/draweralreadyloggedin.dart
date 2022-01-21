import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:widget_test/add_payment_screen.dart';

import 'account.dart';

class DrawerAlreadyLoggedIn extends StatelessWidget {
  const DrawerAlreadyLoggedIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor:
            Colors.white, //This will change the drawer background to blue.
        //other styles
      ),
      child: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: SafeArea(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              // const DrawerHeader(
              //   decoration: BoxDecoration(
              //     color: Colors.white38,
              //   ),
              //   child: Text('Drawer Header'),
              // ),
              ListTile(
                title:
                    Text('${FirebaseAuth.instance.currentUser!.displayName}'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                },
              ),
              ListTile(
                title: const Text('Account'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Account()));
                },
              ),
              ListTile(
                title: const Text('Wallet'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddPaymentScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

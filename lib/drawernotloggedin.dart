import 'package:flutter/material.dart';
import './login.dart';
import './register.dart';

class DrawerNotLoggedIn extends StatelessWidget {
  const DrawerNotLoggedIn({Key? key}) : super(key: key);

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
                title: const Text('Register'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
              ),
              ListTile(
                title: const Text('Login'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

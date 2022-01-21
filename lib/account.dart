import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () => {Navigator.pop(context)},
                ),
              ),
              Text('Account Info:'),
              Text(''),
              Text('${FirebaseAuth.instance.currentUser}'),
              Text(''),
              Text('${FirebaseAuth.instance.currentUser!.displayName}'),
              Text(''),
              Text('${FirebaseAuth.instance.currentUser!.email}'),
              Text(''),
              Text('${FirebaseAuth.instance.currentUser!.metadata}'),
              Text(''),
              ElevatedButton(
                onPressed: () {
                  signOut();
                },
                child: Text('Log Out'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      //TODO: Nagigate to home

      print('signed Out!');
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    } catch (e) {
      print('e:');
      print(e.toString());
    }
  }
}

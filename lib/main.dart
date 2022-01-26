import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:widget_test/permission.dart';
import './situation.dart';
import './drawernotloggedin.dart';
import './draweralreadyloggedin.dart';
import 'package:http/http.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey =
      "pk_test_51K4dyGCIBIVSqdVSeHxcWVD1iY1trb22b0PmJ796bXSTLnvCBcfRww6JBqUIWg19EDk0CbMpO5FSst56JYeMJYg300uMiehnUr";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StreamSubscription<User?> user;
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: FirebaseAuth.instance.currentUser == null
          ? DrawerNotLoggedIn()
          : DrawerAlreadyLoggedIn(),
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),s
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: IconButton(
                icon: Icon(Icons.menu, color: Colors.black),
                onPressed: () => _scaffoldKey.currentState!.openDrawer(),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FirebaseAuth.instance.currentUser == null
                      ? Text('Hello.\n You are you today?')
                      : Text(
                          'Hello, ${FirebaseAuth.instance.currentUser!.displayName}. \n How are you doing? '),
                  Situation(),
                  ElevatedButton(
                    child: Text('test'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PermissionScreen()));
                    },
                  ),
                  FloatingActionButton(
                    onPressed: () => FirebaseFirestore.instance
                        .collection('testing')
                        .add({'timestamp': Timestamp.fromDate(DateTime.now())}),
                    child: Icon(Icons.add),
                  ),
                  Expanded(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('testing')
                            .snapshots(),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot,
                        ) {
                          if (!snapshot.hasData) return const SizedBox.shrink();
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                final docData = snapshot.data!.docs[index];
                                final dateTime =
                                    (docData['timestamp'] as Timestamp);
                                return ListTile(
                                    title: Text(dateTime.toString()));
                              });
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

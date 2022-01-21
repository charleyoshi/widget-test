import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:widget_test/globals.dart';
import 'package:geolocator/geolocator.dart';
import 'package:widget_test/you_got_someone_screen.dart';

class FindRideNearbyScreen extends StatefulWidget {
  const FindRideNearbyScreen(
      {Key? key,
      @required this.docID,
      @required this.origin,
      @required this.destination})
      : super(key: key);
  final docID;
  final origin;
  final destination;
  @override
  State<FindRideNearbyScreen> createState() => _FindRideNearbyScreenState();
}

class _FindRideNearbyScreenState extends State<FindRideNearbyScreen> {
  bool _isCancel = false;

  void deleteFinds(String Id) async {
    // TODO: add if haveFound == true -> do nothing and return
    var doc =
        await FirebaseFirestore.instance.collection('finds').doc(Id).get();
    if (doc.exists) {
      if (doc.data()!['haveFound']) {
        return;
      }
    }
    setState(() {
      _isCancel = true;
    });
    FirebaseFirestore.instance
        .collection('finds')
        .doc(Id)
        .delete()
        .catchError((e) {
      print('------Cannot delete from finds: $e');
    });
    print('deleted finds $Id');
    final snackBar = SnackBar(content: Text('Trip cancelled.'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// THIS WORKS!!!!!!!
// 1. Use origin & destination, which are two tuples of (double, double), to find their placemark in initState
// 2. Use setState to set the value
  String _addressOrigin = '';
  String _addressDestination = '';

  @override
  void initState() {
    getPlaceMark(widget.origin.item1, widget.origin.item2)
        .then((value) => setState(() {
              _addressOrigin = value;
            }));
    getPlaceMark(widget.destination.item1, widget.destination.item2)
        .then((value) => setState(() {
              _addressDestination = value;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0),
                ),
                child: Text(
                  'Finding your ride...',
                  style: const TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              )),
          Positioned(
              top: 55,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Text(
                  'Your current location: \n\t$_addressOrigin\nYou want to go to: \n\t$_addressDestination\n',
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              )),
          _isCancel // <- This prevents StreamBuilder from calling the doc in stream that doesn't exist anymore
              ? Positioned(
                  bottom: 20,
                  child:
                      Text('Cancelled')) // will only appear about half a second
              : StreamBuilder(
                  //StreamBuilder is for listen to 'haveFound' in realtime
                  stream: FirebaseFirestore.instance
                      .collection("finds")
                      .doc(widget.docID)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    // 試下 stream係all documents
                    // if (snapshot.hasData) -> if (snapshot contain widget.docID)
                    // Final resort: add a bool 'isCancel'. Don't even show streambuilder if isCancel == true
                    if (snapshot.hasData) {
                      // if 'haveFound' == false -> show 'Cancel' button
                      if (!snapshot.data!['haveFound']) {
                        // return ElevatedButton(
                        //   onPressed: () => deleteFinds(widget.docID),
                        //   child: Text('Cancel'),
                        // );
                        return Positioned(
                            bottom: 20,
                            child: GestureDetector(
                              onTap: () => deleteFinds(widget.docID),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 80.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(0.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 2),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'Cancel',
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                            ));
                      } else {
                        // vvv Got error here, maybe see if connectionState is helpful (Error: Tried to navigate (build another state) while streambuilder is still building)
                        // Resolve: wrap Navigator with Future.microtask. This will schedule it to happen on
                        //    the next async task cycle (i.e. after build is complete).
                        Future.microtask(() => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    YouGotSomeoneScreen(docID: widget.docID))));
                        return Text('You got someone!');
                      }
                    }
                    if (!snapshot.hasData) {
                      // Error checking
                      return Text('empty');
                    }
                    if (snapshot.hasError) {
                      // Error checking
                      return Text('snapshot has error');
                    }
                    return Text(
                        'hello'); // TODO: add snapshot.connectionState maybe
                  },
                ),
          Positioned(
            top: 20,
            left: 10,
            child: Container(
              margin: EdgeInsets.all(10),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.red),
                onPressed: () => {Navigator.pop(context)},
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

// vvv Problem: this widget used here gives error in debug console
//   Positioned(
//       bottom: 20,
//       child: GestureDetector(
//         onTap: () => deleteFinds(widget.docID),
//         child: Container(
//           padding: const EdgeInsets.symmetric(
//             vertical: 18.0,
//             horizontal: 80.0,
//           ),
//           decoration: BoxDecoration(
//             color: Colors.black,
//             borderRadius: BorderRadius.circular(0.0),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black26,
//                 offset: Offset(0, 2),
//                 blurRadius: 6.0,
//               ),
//             ],
//           ),
//           child: Text(
//             'Cancel',
//             style: const TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white),
//           ),
//         ),
//       )),

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geocoding/geocoding.dart';
import 'package:widget_test/globals.dart';

class YouGotSomeoneScreen extends StatefulWidget {
  const YouGotSomeoneScreen({
    Key? key,
    @required this.docID,
  }) : super(key: key);
  final docID;

  @override
  _YouGotSomeoneScreenState createState() => _YouGotSomeoneScreenState();
}

class _YouGotSomeoneScreenState extends State<YouGotSomeoneScreen> {
  String giverName = '';
  String giverGender = '';
  String giverOriginAddress = ''; // used in 'Coming from'
  int pin = 0;
  final db = FirebaseFirestore.instance.collection('finds');

  void asyncMethod() async {
    var docSnapshot = await db.doc(widget.docID).get();
    if (docSnapshot.exists) {
      if ((docSnapshot.data()!['haveFound'])) {
        var giverSnapshot =
            await db.doc(widget.docID).collection('giver').get();
        if (giverSnapshot.docs.length == 1) {
          var giverInfo = await giverSnapshot.docs[0].data();
          print('-------giverInfo-------');
          print(giverInfo);
          // giverInfo = {giverDestination: Instance of 'GeoPoint', giverName: charley, giverOrigin: Instance of 'GeoPoint', addTime: Timestamp(seconds=1637768332, nanoseconds=681764000)}

          setState(() {
            giverName = giverInfo['giverName'];
            // giverGender = giverInfo['']
            pin = giverInfo['pin'];
          });
          giverOriginAddress = await getPlaceMark(
              giverInfo['giverOrigin'].latitude,
              giverInfo['giverOrigin'].longitude);
        }
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    asyncMethod();
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
                  ' ${giverName} is picking you up',
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              )),
          // vvv InfoBox: giverImage, giverName, giverGender
          // This widget gives "Exception caught by widget library": Incorrect use of ParentDataWidget.
          // TODO: get rid of this exception
          Positioned(
              top: 100,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.12,
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 20.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Positioned(
                    right: 20,
                    bottom: 20,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        'Name: ${giverName}\nGender: ${giverGender}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    )),
              )),
          Positioned(
              top: 200,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                // height: MediaQuery.of(context).size.height * 0.18,
                // padding: const EdgeInsets.symmetric(
                //   vertical: 12.0,
                //   horizontal: 20.0,
                // ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'PIN: ${pin} (Show this to the rider to confirm)\nComing from: ${giverOriginAddress}',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              )),
        ],
      ),
    ));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geocoding/geocoding.dart';
import 'package:widget_test/globals.dart';

class PickUpYourVoyagerScreen extends StatefulWidget {
  const PickUpYourVoyagerScreen(
      {Key? key,
      required this.docID,
      required this.finderName,
      required this.finderOriginAddress,
      required this.finderDestinationAddress,
      required this.finderGender})
      : super(key: key);
  final String finderName;
  final String finderOriginAddress;
  final String finderDestinationAddress;
  final String finderGender;
  final docID;
  @override
  State<PickUpYourVoyagerScreen> createState() =>
      _PickUpYourVoyagerScreenState();
}

class _PickUpYourVoyagerScreenState extends State<PickUpYourVoyagerScreen> {
  final db = FirebaseFirestore.instance.collection('finds');
  // TODO: check every second if ride is cancelled
  int pin = 0;
  late GoogleMapController _googleMapController;
  TextEditingController _pinTextFieldController = TextEditingController();

  void setPin() async {
    var docSnapshot = await db.doc(widget.docID).get();
    if (docSnapshot.exists) {
      if ((docSnapshot.data()!['haveFound'])) {
        QuerySnapshot giverSub =
            await db.doc(widget.docID).collection('giver').get();
        if (giverSub.docs.length == 1) {
          pin = (giverSub.docs[0].data() as Map)['pin'];
        } else {
          // For error check
          // Giver Collection length of doc =/= 1
          // Should not happen
        }
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    setPin();
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    _pinTextFieldController.dispose();
    super.dispose();
  }

  var _initialCameraPosition = CameraPosition(
    target: LatLng(22.2782, 114.1821),
    zoom: 18.5,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
          ),
          Positioned(
              top: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0),
                ),
                child: Text(
                  'Pick Up Your Voyager',
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              )),
          Positioned(
              top: 70,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Text(
                  'Name: ${widget.finderName} \nGender: ${widget.finderGender}\n\nYour voyager is at: \n${widget.finderOriginAddress}\nGoing to: \n${widget.finderDestinationAddress}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              )),

          // enter PIN, correct: can collect money. Ride start
          Positioned(
              bottom: 180,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0),
                ),
                child: Text(
                  'Enter PIN',
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              )),

          /// TODO: back arrow to be removed
          TextField(
            controller: _pinTextFieldController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'PIN'),
            onChanged: (pinInput) {
              if (pinInput == pin.toString()) {
                print('Correct! Pin is');
                print(pin);
                // START RIDE
              } else if (pinInput.length >= 4) {
                print('incorrect Pin.');
                setState(() {
                  _pinTextFieldController.clear();
                });
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Incorrect PIN.')));
              }
              // If pinInput.length >=4 -> clear textfield
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

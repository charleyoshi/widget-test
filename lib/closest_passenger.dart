import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geocoding/geocoding.dart';
import 'package:widget_test/directions_model.dart';
import 'package:widget_test/directions_repo.dart';
import 'package:widget_test/globals.dart';
import 'package:widget_test/pickup_your_voyager_screen.dart';
import 'dart:math';

class ClosestPassengerScreen extends StatefulWidget {
  const ClosestPassengerScreen({
    Key? key,
    @required this.closestPointID,
    @required this.giverOwnOrigin,
    @required this.giverOwnDestination,
  }) : super(key: key);
  final closestPointID;
  final giverOwnOrigin;
  final giverOwnDestination;
  @override
  State<ClosestPassengerScreen> createState() => _ClosestPassengerScreenState();
}

class _ClosestPassengerScreenState extends State<ClosestPassengerScreen> {
  Random random = Random();

  void decline() {
    final snackBar =
        SnackBar(content: Text('You declined the ride. Try offer again.'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }

  final db = FirebaseFirestore.instance.collection('finds');

  String finderName = '';
  String finderOriginAddress = ''; // Address a.k.a placemark
  String finderDestinationAddress = ''; // Address a.k.a placemark
  Map<String, dynamic>?
      _voyagerInfo; // {origin: Instance of 'GeoPoint', destination: Instance of 'GeoPoint', haveFound: false, totalDistance: 6.9 km, finderName: charley, totalDuration: 14 mins, addDate: Timestamp(seconds=1637027867, nanoseconds=696600000)}
  var _initialCameraPosition =
      CameraPosition(target: LatLng(20, 114), zoom: 20);
  Directions? _route;
  // Find by docID
  void asyncMethod() async {
    var docSnapshot = await db.doc(widget.closestPointID).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      // You can then retrieve the value from the Map like this:
      finderName = data?['finderName'];
      LatLng finderOriginLatLng =
          LatLng(data?['origin'].latitude, data?['origin'].longitude);
      LatLng finderDestinationLatLng =
          LatLng(data?['destination'].latitude, data?['destination'].longitude);

      final _routeDirection = await DirectionsRepo().getDirections(
          origin: finderOriginLatLng, destination: finderDestinationLatLng);

      setState(() {
        _voyagerInfo = data; // <- Can use outside this function
        _route = _routeDirection;
      });

      finderOriginAddress = await getPlaceMark(
          data?['origin'].latitude, data?['origin'].longitude);
      finderDestinationAddress = await getPlaceMark(
          data?['destination'].latitude, data?['destination'].longitude);

      _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: finderOriginLatLng, zoom: 18.5)));

      setState(() {});
    }
  }

  late GoogleMapController _googleMapController;

  @override
  void initState() {
    asyncMethod(); // Because async can't happen in initState (Can try streambuilder)
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  Future<bool> isRideExist() async {
    var docSnapshot = await db.doc(widget.closestPointID).get();
    if (docSnapshot.exists) {
      return true;
    }
    return false;
  }

  Future<bool> turnHaveFoundtoTrue() async {
    var docSnapshot = await db.doc(widget.closestPointID).get();
    if (docSnapshot.exists) {
      // if it's false -> turn it to true, otherwise something's wrong
      if (!(docSnapshot.data()!['haveFound'])) {
        db.doc(widget.closestPointID).update({'haveFound': true});
        return true;
      }
    }
    return false;
  }

  Future<bool> _insertSubCollection() async {
    var docSnapshot = await db.doc(widget.closestPointID).get();
    if (docSnapshot.exists) {
      if ((docSnapshot.data()!['haveFound'])) {
        db.doc(widget.closestPointID).collection('giver').add({
          'giverName': FirebaseAuth.instance.currentUser!.displayName,
          'addTime': Timestamp.fromDate(DateTime.now()),
          'giverOrigin': GeoPoint(
              widget.giverOwnOrigin.item1, widget.giverOwnOrigin.item2),
          'giverDestination': GeoPoint(widget.giverOwnDestination.item1,
              widget.giverOwnDestination.item2),
          'pin': random.nextInt(8999) + 1000,
        });
        return true;
      }
    }
    return false;
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
                  'FOUND!',
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
                  'Your voyager is at: \n\t$finderOriginAddress\nGoing to: \n\t$finderDestinationAddress\nGender:',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              )),
          Positioned(
              top: 200,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.45,
                child: GoogleMap(
                  initialCameraPosition: _initialCameraPosition,
                  onMapCreated: (controller) =>
                      _googleMapController = controller,
                  polylines: {
                    if (_route != null)
                      Polyline(
                        polylineId: const PolylineId('overview_polyline'),
                        color: Colors.pink,
                        width: 7,
                        points: _route!.polylinePoints
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList(),
                      ),
                  },
                ),
              )),
          // Accept
          Positioned(
              bottom: 80,
              child: GestureDetector(
                onTap: () async {
                  // check if ride still exist : get people from the pool： 1.create rideID and 2. PIN

                  final bool rideExist = await isRideExist();

                  if (rideExist) {
                    // turn 'haveFound' to true (block finder from cancelling)
                    // TODO: vvv still throw exception when try to update (but another side try to cancel)
                    // TODO: try: lock the doc first, prevent finder from deleting at this point
                    final bool turnhaveFoundtoTrue =
                        await turnHaveFoundtoTrue();
                    // ^^^ vvv bool is true if sucessfully turned true, for error check
                    if (turnhaveFoundtoTrue) {
                      // firestore: 喺find_ride_screen.dart 果度 detect到 haveFound ==true就轉畫面 去 you got someone screen
                      // final _insertIntoTree = await _insertInto();
                      final bool subSuccess = await _insertSubCollection();
                      print('----_insertSubCollection----');

                      print(subSuccess);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => // TODO: add gender
                                  PickUpYourVoyagerScreen(
                                    finderName: finderName,
                                    finderGender: 'Male',
                                    finderOriginAddress: finderOriginAddress,
                                    finderDestinationAddress:
                                        finderDestinationAddress,
                                    docID: widget.closestPointID,
                                  )));
                    } else {
                      // Error Check
                      final snackBar = SnackBar(
                          content: Text(
                              'Something\'s wrong. (Can\'t turn doc to true.'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pop(context);
                    }
                  } else {
                    final snackBar = SnackBar(
                        content:
                            Text('Ride doesnt exist anymore. Find again?'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);
                  }
                  //2.  喺haveFound下面加自己info & 2locations &
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18.0,
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
                    ' Accept',
                    style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              )),

          // Decline
          Positioned(
              bottom: 20,
              child: GestureDetector(
                onTap: decline,
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
                    'Decline',
                    style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              )),
        ],
      ),
    ));
  }
}

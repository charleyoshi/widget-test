import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widget_test/directions_model.dart';
import 'package:widget_test/directions_repo.dart';
import 'package:widget_test/find_ride_screen.dart';
import 'package:widget_test/login.dart';
import 'package:widget_test/register.dart';
import 'package:tuple/tuple.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var _initialCameraPosition = CameraPosition(
    target: LatLng(22.2782, 114.1821),
    zoom: 18.5,
  );

  late var _userPosition;

  CameraPosition _setUserPosition(double lat, double long) {
    return CameraPosition(target: LatLng(lat, long), zoom: 18.5);
  }

  String _userLocation = '';

  // is called only when PermissionStatus is Granted
  Future<Position> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print('serviceEnabled:');
    print(serviceEnabled); // true

    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('1. Location services are disabled.'),
        duration: Duration(seconds: 3),
      ));
      return Future.error('1. Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    print('permission: ');
    print(permission); //deniedForever
    if (permission != null &&
        permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever) {
      var x = await Geolocator.getCurrentPosition();
      print('--------');
      print(x);
      print('--------');
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } else {
      throw '!Permission is $permission';
    }
  }

  late GoogleMapController _googleMapController;
  Marker? _origin;
  Marker? _destination;
  Directions? _info;

  @override
  void dispose() {
    // TODO: implement dispose
    _googleMapController.dispose();
    super.dispose();
  }

  // Add to Firestore: 2GeoPoints, Distance and Duration
  Future<DocumentReference> addFinds() {
    // Call the user's CollectionReference to add a new user
    final db = FirebaseFirestore.instance;
    return db.collection('finds').add({
      'origin': GeoPoint(
          _origin!.position.latitude, _origin!.position.longitude), // John Doe
      'destination': GeoPoint(_destination!.position.latitude,
          _destination!.position.longitude), // Stokes and Sons
      'totalDistance': _info!.totalDistance,
      'totalDuration': _info!.totalDuration, // 42
      'finderName': FirebaseAuth.instance.currentUser!.displayName,
      'finderID': FirebaseAuth.instance.currentUser!.uid,
      'addDate': Timestamp.fromDate(DateTime.now()),
      'haveFound': false,
    }).catchError((error) => print("------------:Failed to add finds: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (controller) => _googleMapController = controller,
          markers: {
            if (_origin != null) _origin!,
            if (_destination != null) _destination!
          },
          onLongPress: _addMarker,
          polylines: {
            if (_info != null)
              Polyline(
                polylineId: const PolylineId('overview_polyline'),
                color: Colors.black,
                width: 7,
                points: _info!.polylinePoints
                    .map((e) => LatLng(e.latitude, e.longitude))
                    .toList(),
              ),
          },
        ),
        if (_info != null)
          Positioned(
              top: 50,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
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
                  '${_info!.totalDistance}, ${_info!.totalDuration}',
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              )),
        Positioned(
          top: 20,
          left: 10,
          child: Container(
            margin: EdgeInsets.all(10),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => {Navigator.pop(context)},
            ),
          ),
        ),
        if (_info != null)
          Positioned(
              bottom: 20,
              child: GestureDetector(
                onTap: () async {
                  if (FirebaseAuth.instance.currentUser == null) {
                    final snackBar = SnackBar(
                        content: Text('Looks like you haven\'t signed in!'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  } else {
                    final _findID = await addFinds();
                    print('added \'${_findID.id}\' to finds');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FindRideNearbyScreen(
                                  docID: _findID.id,
                                  origin: Tuple2<double, double>(
                                      _origin!.position.latitude,
                                      _origin!.position.longitude),
                                  destination: Tuple2<double, double>(
                                      _destination!.position.latitude,
                                      _destination!.position.longitude),
                                )));
                  }
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
                    'Find',
                    style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              )),
      ]),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.black,
          // onPressed: () => _googleMapController.animateCamera(
          //       CameraUpdate.newCameraPosition(_initialCameraPosition),
          //     ),
          onPressed: () async {
            var _status = await Permission.locationWhenInUse.request();
            if (_status == PermissionStatus.granted) {
              Position _position = await _getUserLocation();
              print(_position); // Latitude: 22.6211049, Longitude: 120.2829511
              print('---------');
              _userPosition =
                  _setUserPosition(_position.latitude, _position.longitude);

              _googleMapController
                  .animateCamera(CameraUpdate.newCameraPosition(_userPosition));
            } else {
              _askPermission(_status);
            }
          },
          child: const Icon(Icons.my_location)),
    );
  }

  Future<void> _askPermission(PermissionStatus _status) async {
    // either denied / restricted / permanentlyDenied
    if (_status == PermissionStatus.permanentlyDenied) {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text('Location Permission'),
                content: Text('Do you want to enable location permission?'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text('Settings'),
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ));
    } else if (_status == PermissionStatus.denied) {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text('Location Permission'),
                content: Text('Do you want to enable location permission?'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text('Settings'),
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text('Location Permission'),
                content: Text('Do you want to enable location permission?'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text('Settings'),
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ));
    }
    print('In ask permission: ');
    print(_status); //PermissionStatus.permanentlyDenied
  }

  void _addMarker(LatLng argument) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      // Set origin
      setState(() {
        _origin = Marker(
            markerId: const MarkerId('origin'),
            infoWindow: const InfoWindow(title: 'Origin'),
            position: argument,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen));
        // Reset destination

        _destination = null;
        _info = null;
      });
    } else {
      // Set destination
      setState(() {
        _destination = Marker(
            markerId: const MarkerId('destination'),
            infoWindow: const InfoWindow(title: 'Destination'),
            position: argument,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue));
        // Reset destination
      });
      final directions = await DirectionsRepo()
          .getDirections(origin: _origin!.position, destination: argument);
      setState(() => _info = directions);
    }
  }
}

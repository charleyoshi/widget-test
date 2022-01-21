import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:widget_test/directions_model.dart';
import 'package:widget_test/directions_repo.dart';

class MapScreen2 extends StatefulWidget {
  const MapScreen2({Key? key}) : super(key: key);

  @override
  _MapScreen2State createState() => _MapScreen2State();
}

class _MapScreen2State extends State<MapScreen2> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
  );

  late GoogleMapController _googleMapController;
  Marker? _origin;
  Marker? _destination;
  Directions? _info;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(centerTitle: false, title: const Text('GoogleMaps'), actions: [
        if (_origin != null)
          TextButton(
            child: const Text('ORIGIN'),
            style: TextButton.styleFrom(
                primary: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.w600)),
            onPressed: () => _googleMapController
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: _origin!.position,
              zoom: 18.5,
              tilt: 50.0,
            ))),
          ),
        if (_destination != null)
          TextButton(
            child: const Text('DESTINATION'),
            style: TextButton.styleFrom(
                primary: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.w600)),
            onPressed: () => _googleMapController
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: _destination!.position,
              zoom: 14.5,
              tilt: 50.0,
            ))),
          ),
      ]),
      body: Stack(alignment: Alignment.center, children: [
        GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          // vvv like a floating action button with 'aim target' icon
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: false,
          onCameraMove: (CameraPosition cameraPosition) {
            print(cameraPosition.zoom);
          },
          onMapCreated: (controller) => _googleMapController = controller,
          markers: {
            if (_origin != null) _origin!,
            if (_destination != null) _destination!
          },
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
          onLongPress: _addMarker,
        ),
        if (_info != null)
          Positioned(
              top: 20.0,
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
        SafeArea(
          child: Container(
            margin: EdgeInsets.all(10),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => {Navigator.pop(context)},
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.black,
          onPressed: () => _googleMapController.animateCamera(
                _info != null
                    ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
                    : CameraUpdate.newCameraPosition(_initialCameraPosition),
              ),
          child: const Icon(Icons.my_location)),
    );
  }

  void _addMarker(LatLng argument) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      // Set origin
      print('------------------------');
      print('case 1 before ');
      // print(_origin);
      // print(_destination);
      print('---------------');
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          // can also define a subtitle, snippet, and onTap for the window
          infoWindow: const InfoWindow(title: 'Origin', snippet: 'Snippet'),
          position: argument,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        );
        // Reset destination
        _destination = null;
        print('case 1 After ');
        // print(_origin);
        // print(_destination);
        print('---------------');

        // Reset info
        _info = null;
      });
    } else {
      // Set destination
      print('---------------------------');
      print('case 2 Before');
      // print(_origin);
      // print(_destination);
      print('-------------------');
      setState(() {
        _destination = Marker(
            markerId: const MarkerId('destination'),
            infoWindow: const InfoWindow(title: 'Destination'),
            position: argument,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue));
      });
      print('case 2 After');
      // print(_origin);
      // print(_destination);
      print('-----------------------');

      //Get directions
      final directions = await DirectionsRepo()
          .getDirections(origin: _origin!.position, destination: argument);
      setState(() => _info = directions);
    }
  }
}

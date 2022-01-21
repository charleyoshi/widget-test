import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final LatLngBounds bounds; // used to center the camera
  final List<PointLatLng> polylinePoints; // list of points to draw the polyline
  final String totalDistance;
  final String totalDuration;

  const Directions(
      {required this.bounds,
      required this.polylinePoints,
      required this.totalDistance,
      required this.totalDuration});

  factory Directions.fromMap(Map<String, dynamic> map) {
    print('-------------------');
    print('in factory....');
    // Check if route is not available
    try {
      if (!((map['routes'] as List).isEmpty)) {
        // Get the route information
        final data = Map<String, dynamic>.from(map['routes'][0]);

        // Bounds

        //    bounds:
        //      {northeast:
        //          {lat: 37.7476659,
        //           lng: -122.4150964},
        //       southwest:
        //          {lat: 37.6670365,
        //           lng: -122.4792629}},
        final northeast = data['bounds']['northeast'];
        final southwest = data['bounds']['southwest'];
        final bounds = LatLngBounds(
          northeast: LatLng(northeast['lat'], northeast['lng']),
          southwest: LatLng(southwest['lat'], southwest['lng']),
        );

        // Distance & Duration are already calculated for us,
        // so we can grab this string version for each
        String distance = '';
        String duration = '';
        if ((data['legs'] as List).isNotEmpty) {
          final leg = data['legs'][0];
          distance = leg['distance']
              ['text']; // distance: {text: 9.5 mi, value: 15247},
          duration = leg['duration']
              ['text']; // duration: {text: 23 mins, value: 1351},
        }
        print('ok');
        return Directions(
            bounds: bounds,
            polylinePoints: PolylinePoints()
                .decodePolyline(data['overview_polyline']['points']),
            totalDistance: distance,
            totalDuration: duration);
      }
    } catch (e) {
      print('E:');
      print(e);
    }
    throw 'something went wrong, maybe two points are way too far away from each other';
  }
}

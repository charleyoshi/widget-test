import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

// Future<bool> haveLoggedIn () async {
//   if (await FirebaseAuth.instance.currentUser != null) {
//     // signed in
//     return true;
// } else {
//   return true;
// }
// }

bool addOne(num) {
  if (num < 10) {
    num = num + 1;
    return true;
  }
  return false;
}

double getMeters(String distance) {
  // eg. '15.1 km' -> 15100
  // eg. '300 m' -> 300
  // eg. '0.3 mi' -> 482.803
  var splitList = distance.split(' ');
  if (splitList.length == 2) {
    // num = 15.0, unit = 'km'
    double num = double.parse(splitList[0]);
    final unit = splitList[1];
    switch (unit) {
      // m, km, mi
      case 'm':
        num = num;
        break;
      case 'km':
        num = num * 1000;
        break;
      case 'mi':
        num = num * 1609.344;
        break;
      default:
        throw 'unit not in m/km/mi';
    }
    return num;
  }
  throw 'splitList.length is not 2';
}

Future<String> getPlaceMark(double lat, double lng) async {
  List<Placemark> placemarksOrigin = await placemarkFromCoordinates(lat, lng);
  Placemark placeMark = placemarksOrigin[0];
  final name = placeMark.name; // Times Square
  final subLocality = placeMark.subLocality; // Canal Road
  final locality = placeMark.locality; // Causeway Bay
  final administrativeArea = placeMark.administrativeArea; // Hong Kong SAR
  final postalCode = placeMark.postalCode; // ' '
  final country = placeMark.country; // China
  final address = "${name}, ${subLocality}";

  return (address);
}

// voyager personal info shouldn't show up until pickup screen 
// ^^^ accept sin show voyager info
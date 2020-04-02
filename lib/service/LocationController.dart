import 'dart:async';
import 'dart:core';

import 'package:location/location.dart';
import 'package:flutter/services.dart' show PlatformException;

class LocationController {

  final Map<String, double> fromLocation = new Map();
  LocationData _location;

  // attributs for GPS Location
  final Location location = new Location();
  String error;
  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSubscription;

  Future<Map<String, double>> getCurrentLocationOfDevice() async {
    Map<String, double> myLocation = null;

    try {
      //myLocation = await location.getLocation();
      LocationData _locationResult = await location.getLocation();
      //myLocation  = await location.getLocation();
      myLocation = new Map();
      if(_locationResult != null){
        myLocation['latitude'] = _locationResult.latitude;
        myLocation['longitude'] = _locationResult.longitude;
      }
      error = "";
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = "Permission denied";
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
        "Permission denied - please ask the user to enable it from the app settings";
      }
      myLocation = null;
    }

    this.currentLocation = myLocation;

    print(
        "Device latitude  : ${this.currentLocation == null ? 'N/A' : this.currentLocation['latitude']}");
    print(
        "Device longitude : ${this.currentLocation == null ? 'N/A' : this.currentLocation['longitude']}");

    /*
    locationSubscription =
        location.onLocationChanged().listen((Map<String, double> result) {
          currentLocation = result;
          return currentLocation;
        });
    */
    return currentLocation;
  }

  void setFromLocation(Map<String, double> fromLocation) {
    this.fromLocation['latitude'] = fromLocation['latitude'];
    this.fromLocation['longitude'] = fromLocation['longitude'];
  }
}

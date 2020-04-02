import 'dart:convert';
import 'package:flutter/material.dart' as material;
import 'package:vector_math/vector_math.dart';
import 'dart:math';

List<Spot> spotsFromJson(String str) {
  final jsonData = json.decode(str);

  return List<Spot>.from(
      jsonData['d']['spots'].map((x) => Spot.fromJson(x)));
}

List<String> placeSpotsFromJson(String str) {
  final jsonData = json.decode(str);
  return List<String>.from(
      jsonData['d']['spots'].map((x) => Spot.fromJson(x).place));
}

List<String> kindSpotsFromJson(String str) {
  final jsonData = json.decode(str);
  return List<String>.from(
      jsonData['d']['spots'].map((x) => Spot.fromJson(x).kind));
}

Spot spotFromJson(String str) {
  final jsonData = json.decode(str);
  return Spot.fromJson(jsonData);
}

class Spot {
  // Used only in debug mode
  String numid;
  // spot title
  String title;
  // a list of pictures, the first picture will be the main
  List<String> pictures;

  String description;
  String summary;
  int deathLimit;
  String deathInterest;
  String amer;
  String historic;
  String illustration;
  String rescuePoint;
  String windDirectionNotAllowed;
  String place;

  // "type"
  double longitude;
  double latitude;
  // is gps position has bean alreeady verified ?
  bool positionVerified;
  String kind;

  Spot({
    this.numid,
    this.title,
    this.pictures,
    this.description,
    this.summary,
    this.deathLimit,
    this.deathInterest,
    this.amer,
    this.historic,
    this.illustration,
    this.rescuePoint,
    this.windDirectionNotAllowed,
    this.place,
    this.longitude,
    this.latitude,
    this.positionVerified,
    this.kind,
  });

  factory Spot.fromJson(Map<String, dynamic> json) => Spot(
    numid: json["id"] == null ? null : json["id"],
    title: json["name"] == null ? '' : json["name"],
    pictures: json["photos"] == null ? null : json["photos"].split(' | '),
    description: json["description"] == null ? '' : json["description"],
    summary: json["resume"] == null ? '' : json["resume"],
    deathLimit: json["profondeurMax"] == null ? 60 : int.parse(json["profondeurMax"]),
    deathInterest: json["zoneInteret"] == null ? '' : json["zoneInteret"] + " m",
    amer: json["amer"] == null ? '' : json["amer"],
    historic: json["historique"] == null ? '' : json["historique"],
    illustration: json["illustration"] == null ? '' : json["illustration"],
    rescuePoint: json["lieuEvacuation"] == null ? '' : json["lieuEvacuation"],
    windDirectionNotAllowed: json["directionVentAEviter"] == null ? '' : json["directionVentAEviter"],
    place: json["zoneGeographique"] == null ? '' : json["zoneGeographique"],
    longitude: json["longitude"] == null ? 0.0 : double.parse(json["longitude"]),
    latitude: json["latitude"] == null ? 0.0 : double.parse(json["latitude"]),
    positionVerified: json["gpsValide"] == null ? false : json["gpsValide"] == 'true',
    kind: json["type"] == null ? '' : json["type"],
  );

  //boolean is
  bool get isHarbor{
    return kind == 'port';
  }

  double getDistanceFromHereInKm(Map<String, double> fromLocation) {

    //print(fromLocation);

    double fromLatitude = null;
    double fromLongitude = null;

    // Port de saint mandrier : 43.075775, 5.899391
    double latitudePortSaintMandrier = 43.075775;
    double longitudePortSaintMandrier = 5.899391;

    double latitudeSCAAnnecyPlongee = 45.89792728258401;
    double longitudeSCAAnnecyPlongee = 6.1317678960456306;

    if(fromLocation != null){
      // location of the device
      fromLongitude = fromLocation['longitude'];
      fromLatitude = fromLocation['latitude'];
    }else {
      // sinon disont qu'on part d'ailleurs
      fromLatitude = latitudeSCAAnnecyPlongee;
      fromLongitude = longitudeSCAAnnecyPlongee;
    }
    //fromLatitude = latitudePortSaintMandrier;
    //fromLongitude = longitudePortSaintMandrier;

    double toLatitude = latitude;
    double toLongitude = longitude;

    // haversine
    // distance between latitudes and longitudes
    double dLat = radians(toLatitude - fromLatitude);
    double dLon = radians(toLongitude - fromLongitude);

    // convert to radians
    double fromLatRadian = radians(fromLatitude);
    double toLatRadian = radians(toLatitude);

    // apply haversine formulae
    var a = pow(sin(dLat / 2), 2) +
           (pow(sin(dLon / 2), 2) * cos(fromLatitude) * cos(toLatitude));

    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var radius = 6371;

    double distanceEnKm = radius * c;
    // decoration to display only significant datas : distance in format (meter)
    double distanceEnKmArrondis = double.parse(distanceEnKm.toStringAsFixed(3));
    return distanceEnKmArrondis;
  }

  String getTimeToGo(Map<String, double> currentLocation) {
    double timeToGoInMinute = getDistanceFromHereInKm(currentLocation) / 14 * 60;
    int numberOfHour = 0;
    while (timeToGoInMinute > 60) {
      numberOfHour++;
      timeToGoInMinute = timeToGoInMinute - 60;
    }
    String hourPrefix = '';
    if(numberOfHour > 0) {
      hourPrefix = '${numberOfHour}h';
    }
    return '${hourPrefix}${timeToGoInMinute.toStringAsFixed(0)} min';
  }

  bool operator ==(o) => o is Spot && o.numid == numid;

  int get hashCode => numid.hashCode;

  bool startPoint(double lat, double long) => latitude == lat && longitude == long;

  material.Color getIconColor(){
    if(isHarbor){
      return material.Colors.black;
    }else{
      if(deathLimit > 60){
       return material.Colors.black;
      }else if( deathLimit > 40) {
        return material.Colors.red;
      }else if( deathLimit > 20) {
        return material.Colors.orange;
      }else{
        return material.Colors.green.shade900;
      }
    }
  }

  material.Icon getIcon(double fromLat, double fromLong) {
    if(latitude == fromLat && longitude == fromLong){
      return material.Icon(material.Icons.flag);
    }else if(isHarbor){
      return material.Icon(material.Icons.directions_boat);
    }else{
      return material.Icon(material.Icons.location_on);
    }
  }

  material.Icon getIconKind() {
    switch(kind) {
      case "port": { return material.Icon(material.Icons.directions_boat); }
      break;

      case "tombant": { return material.Icon(material.Icons.filter_hdr); }
      break;

      case "épave": { return material.Icon(material.Icons.airplanemode_active); }
      break;

      case "epave": { return material.Icon(material.Icons.airplanemode_active); }
      break;

      default: { return material.Icon(material.Icons.location_on); }
      break;
    }
  }
}
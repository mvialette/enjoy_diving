
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:enjoy_diving/incubator6/ApplicationModel.dart';
import 'package:enjoy_diving/model/RechercheBean.dart';
import 'package:enjoy_diving/model/Spot.dart';
import 'package:queries/collections.dart';

class SpotService {

  Future<List<Spot>> getSpotsByRechercheBean(BuildContext context) async {

    RechercheBean rechercheBean = ApplicationModel.of(context).rechercheBean;

    String json;
    json = await rootBundle.loadString('assets/spots.json');
    List<Spot> allSpots = spotsFromJson(json);

    if(rechercheBean.places.length == 0) {
      List<String> cities = placeSpotsFromJson(json);
      List<String> distinctedCities = new Collection(cities).distinct().toList();
      rechercheBean.places.addAll(distinctedCities);
    }

    if(rechercheBean.kinds.length == 0){
      List<String> kinds = kindSpotsFromJson(json);
      List<String> distinctedKinds = new Collection(kinds).distinct().toList();
      rechercheBean.kinds.addAll(distinctedKinds);
    }

    List<Spot> spotsAvailable;

    Map<String, double> fromLocation = ApplicationModel.of(context).fromLocation;

    spotsAvailable = allSpots.where((spot) =>
        isSpotAvailable(spot, rechercheBean, fromLocation)
    ).toList();

    //spotsAvailable = allSpots;
    debugPrint("spotsAvailable.lenght= ${spotsAvailable.length}");
    return spotsAvailable;
  }

  Future<List<Spot>> getAllSpotsFromJson() async {
    String json;
    json = await rootBundle.loadString('assets/spots.json');

    List<Spot> spotsList = spotsFromJson(json);

    return spotsList;
  }

  Future<List<Spot>> getAllStartSpotsFromJson() async {
    String json;
    json = await rootBundle.loadString('assets/spots.json');

    List<Spot> spotsList = spotsFromJson(json);

    List<Spot> startSpotsAvailable = spotsList.where((spot) =>
        spot.kind == 'port' || spot.kind == 'mise a l eau'
    ).toList();

    return startSpotsAvailable;
  }

  Future<List<List<String>>> getSpotsDistinctedValuesFromJson() async {
    String json;
    json = await rootBundle.loadString('assets/spots.json');

    List<String> cities = placeSpotsFromJson(json);
    List<String> distinctedCities = new Collection(cities).distinct().toList();

    List<String> kinds = kindSpotsFromJson(json);
    List<String> distinctedKinds = new Collection(kinds).distinct().toList();

    List<List<String>> distinctedValues = new List();
    distinctedValues.add(distinctedCities);
    distinctedValues.add(distinctedKinds);

    return distinctedValues;
  }

  bool isSpotAvailable(Spot _spot, RechercheBean _rechercheBean, Map<String, double> fromLocation) {
    bool result = false;
    bool resultDeep = false;
    bool resultKind = false;
    bool resultPlace = false;
    bool resultDistance = false;

    // deep
    int deepMin = 0;
    int deepMax = 0;

    if (_rechercheBean.deep0to20 == true){
      deepMin = 0;
    } else if (_rechercheBean.deep20to40 == true){
      deepMin = 20;
    } else if (_rechercheBean.deep40to60 == true){
      deepMin = 40;
    } else if (_rechercheBean.deep60to70 == true){
      deepMin = 60;
    } else if (_rechercheBean.deep70to120 == true){
      deepMin = 70;
    }

    if (_rechercheBean.deep70to120 == true){
      deepMax = 120;
    } else if (_rechercheBean.deep60to70 == true){
      deepMax = 70;
    } else if (_rechercheBean.deep40to60 == true){
      deepMax = 60;
    } else if (_rechercheBean.deep20to40 == true){
      deepMax = 40;
    } else if (_rechercheBean.deep0to20 == true){
      deepMax = 20;
    }

    if(_spot.deathLimit >= deepMin && _spot.deathLimit <= deepMax) {
      resultDeep = true;

      // kind
      if(_rechercheBean.kinds.contains(_spot.kind)) {
        resultKind = true;

        // place
        if(_rechercheBean.places.contains(_spot.place)) {
          resultPlace = true;

          if(_rechercheBean.distanceValue.compareTo(_spot.getDistanceFromHereInKm(fromLocation)) >= 0) {
            resultDistance = true;
          } else {
            resultDistance = false;
          }
        }
      }
    }

    // All the criterias
    result = resultDeep && resultKind && resultPlace && resultDistance;

    return result;
  }

  String getLocationInWSG84FromDecimal(double locationInDecimal){
    int locationDegree = locationInDecimal.truncate();
    String locationDegreeString = locationDegree.toString().padLeft(2, '0');

    double locationMinutesDouble = (locationInDecimal - locationDegree.toDouble())  * 60;
    int locationMinutesInt = locationMinutesDouble.truncate();
    String locationMinutesString = locationMinutesInt.toString().padLeft(2, '0');

    double locationMillisecDouble = (locationMinutesDouble - locationMinutesInt.toDouble())  * 1000;
    int locationMillisecInt = locationMillisecDouble.truncate();

    String locationMillisecString = locationMillisecInt.toString().padLeft(3, '0');

    return "${locationDegreeString}°${locationMinutesString}'${locationMillisecString}\"";
  }

  String getLocationsInWSG84(double latitude, double longitude){
    return getLocationInWSG84FromDecimal(latitude) + "N, " + getLocationInWSG84FromDecimal(longitude) + "E";
  }
}

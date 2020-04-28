import 'package:enjoy_diving/model/Spot.dart';
import 'package:enjoy_diving/service/SpotService.dart';
import 'package:enjoy_diving/view/component/CustomText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/ApplicationModel.dart';

class SpotDetailLocation extends StatelessWidget {

  SpotService spotService = new SpotService();

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    final Spot spot = ApplicationModel.of(context).toSpot;
    final Map<String, double> fromLocation = ApplicationModel.of(context).fromLocation;

    final double boatSpeed = ApplicationModel.of(context).boatSpeed;

    return ListView(
      children: <Widget>[
        Card(
          color: Colors.indigo.shade300,
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(

              children: <Widget>[
                Text(
                  'Coordonnées GPS',
                  style: textTheme.title,
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.filter_1),
                    CustomText('En décimal:', style: textTheme.subtitle,)
                  ],
                ),
                Row(
                  children: <Widget>[
                    CustomText('${spot.latitude} N', style: textTheme.body1,)
                  ],
                ),
                Row(
                  children: <Widget>[
                    CustomText('${spot.longitude} E', style: textTheme.body1,)
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.location_on),
                    CustomText('WSG84:', style: textTheme.subtitle,)
                  ],
                ),
                Row(
                  children: <Widget>[
                    CustomText('${spotService.getLocationsInWSG84(spot.latitude, spot.longitude)}', style: textTheme.subtitle,)
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Icon(spot.positionVerified ? Icons.check_circle : Icons.warning),
                    CustomText(spot.positionVerified ? 'Vérifiées' : 'Non vérifiées', style: textTheme.body1,),
                  ],
                ),
              ],
            ),
          ),
        ),
        Card(
          color: Colors.indigo.shade100,
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(

              children: <Widget>[
                Text(
                  'Navigation',
                  style: textTheme.title,
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.explore),
                    CustomText('Distance (nb km) depuis où l''on est : ${spot.getDistanceFromHereInKm(fromLocation)} km', style: textTheme.body1,)
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.timer),
                    CustomText('Distance (temps) depuis où l''on est : ${spot.getTimeToGo(fromLocation, boatSpeed)}', style: textTheme.body1,)
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
    /*
          'Les amers : ${spot.amer}',
          style: textTheme.subtitle,
    */
  }
}
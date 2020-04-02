import 'package:enjoy_diving/model/Spot.dart';
import 'package:enjoy_diving/service/SpotService.dart';
import 'package:enjoy_diving/view/component/CustomSpotCard.dart';
import 'package:flutter/material.dart';

import '../ApplicationModel.dart';

class SpotDetailDebug extends StatelessWidget {

  SpotService spotService = new SpotService();

  @override
  Widget build(BuildContext context) {

    final Spot spot = ApplicationModel.of(context).toSpot;
    final Map<String, double> fromLocation = ApplicationModel.of(context).fromLocation;

    return ListView(
        children: <Widget>[
          CustomSpotCard('Spot num_id = ${spot.numid}', Colors.green),
          CustomSpotCard('Device latitude in decimal = ${fromLocation == null ? 'N/A' : fromLocation['latitude']}', Colors.yellow),
          CustomSpotCard('Device longitude in decimal = ${fromLocation == null ? 'N/A' : fromLocation['longitude']}', Colors.green),
          CustomSpotCard('Device in WGS 84 = ${fromLocation == null ? 'N/A' : spotService.getLocationsInWSG84(fromLocation['latitude'], fromLocation['longitude'])}', Colors.yellow),
          CustomSpotCard('Spot latitude in decimal = ${spot.latitude == null ? 'N/A' : spot.latitude}', Colors.green),
          CustomSpotCard('Spot longitude in decimal = ${spot.longitude == null ? 'N/A' : spot.longitude}', Colors.yellow),
          CustomSpotCard('Device in WGS 84 = ${spotService.getLocationsInWSG84(spot.latitude, spot.longitude)}', Colors.green),
        ]
    );
  }
}
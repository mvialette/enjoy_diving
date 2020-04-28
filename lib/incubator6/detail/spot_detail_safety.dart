import 'package:enjoy_diving/model/Spot.dart';
import 'package:enjoy_diving/service/SpotService.dart';
import 'package:enjoy_diving/view/component/CustomSpotCard.dart';
import 'package:flutter/material.dart';
import '../../model/ApplicationModel.dart';

class SpotDetailSafety  extends StatelessWidget {

    SpotService spotService = new SpotService();

    @override
    Widget build(BuildContext context) {

        final Spot spot = ApplicationModel.of(context).toSpot;

        return ListView(
            children: <Widget>[
              CustomSpotCard('Lieu d' 'évacuation : ${spot.rescuePoint}', Colors.pink),
              CustomSpotCard('Vent à éviter : ${spot.windDirectionNotAllowed}', Colors.deepPurple),
            ]
        );
    }
}
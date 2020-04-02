import 'package:enjoy_diving/model/Spot.dart';
import 'package:enjoy_diving/service/SpotService.dart';
import 'package:enjoy_diving/view/component/CustomText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ApplicationModel.dart';

class SpotDetailInformations extends StatelessWidget {

  SpotService spotService = new SpotService();

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    final Spot spot = ApplicationModel.of(context).toSpot;
    final Map<String, double> fromLocation = ApplicationModel.of(context).fromLocation;

    return ListView(
      children: <Widget>[
        Card(
          color: Colors.blue.shade200,
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(

              children: <Widget>[
                Text(
                  'Fiche d\'identité du spot',
                  style: textTheme.title,
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.location_city),
                    Text(
                      'Zone : ${spot.place}',
                      style: textTheme.subtitle,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    spot.getIconKind(),
                    Text(
                      'Type de spot : ${spot.kind}',
                      style: textTheme.subtitle,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.arrow_downward),
                    Text(
                      'Profondeur maxi : ${spot.deathLimit} m',
                      style: textTheme.subtitle,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.layers),
                    Text(
                      'Zone d\'intéret : ${spot.deathInterest}',
                      style: textTheme.subtitle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Card(
          color: Colors.blue.shade100,
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                children: <Widget>[
                  Text(
                    'Résumé',
                    style: textTheme.title,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: CustomText(spot.summary, style: textTheme.body1),
                      ),
                    ],
                  ),
                ]
            ),
          ),
        ),
      ],
    );
  }
}
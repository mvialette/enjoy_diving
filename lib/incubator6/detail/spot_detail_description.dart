import 'package:enjoy_diving/model/Spot.dart';
import 'package:enjoy_diving/service/SpotService.dart';
import 'package:enjoy_diving/view/component/CustomText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/ApplicationModel.dart';

class SpotDetailDescription extends StatelessWidget {

  SpotService spotService = new SpotService();

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    final Spot spot = ApplicationModel.of(context).toSpot;

    return ListView(
      children: <Widget>[
        Card(
          color: Colors.green.shade100,
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                CustomText(spot.description, style: textTheme.body1,)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
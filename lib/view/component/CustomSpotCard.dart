import 'package:flutter/material.dart';

import 'CustomText.dart';

class CustomSpotCard extends StatelessWidget {

  MaterialColor materialColor;
  String spotString;

  CustomSpotCard(this.spotString, this.materialColor);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: materialColor.shade100,
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            CustomText(
              this.spotString,
              style: textTheme.body1,
            )
          ],
        ),
      ),
    );
  }
}

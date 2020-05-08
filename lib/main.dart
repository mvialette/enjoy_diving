import 'package:flutter/material.dart';

import 'incubator6/settings.dart';
import 'incubator6/spot_detail.dart';
import 'incubator6/spot_list.dart';
import 'model/ApplicationModel.dart';

void main() => runApp(EnjoyDivingApp());

class EnjoyDivingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ApplicationModel applicationModel = new ApplicationModel(
      child: MaterialApp(
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.lightBlue,
          accentColor: Colors.brown,
          primaryColorLight: Colors.lightBlue.shade100,
          dividerColor: Colors.grey.shade400,

          // Define the default font family.
          fontFamily: 'Georgia',

          iconTheme:
              new IconThemeData(color: Colors.white, opacity: 1.0, size: 30.0),
          primaryIconTheme: new IconThemeData(
              color: Colors.grey.shade600, opacity: 1.0, size: 30.0),
          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            // headline5 : section
            headline5: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
            ),
            // headline6 : App bar (aka page title)
            headline6: TextStyle(
                fontFamily: 'KaushanScript',
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.white),
            bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'KaushanScript'),
            // default text
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            //bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SpotListPage(),
          '/settings': (context) => SettingsPage(),
          '/spotDetail': (context) => SpotDetailPage(),
        },
      ),
    );
    return applicationModel;
  }
}

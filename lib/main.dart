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
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.brown.shade700, //  <-- dark color
            textTheme: ButtonTextTheme
                .primary, //  <-- this auto selects the right color
          ),
          tabBarTheme: TabBarTheme(
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
                color: Colors.white,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.normal,
                fontFamily: 'Georgia',
                color: Colors.white,
              ),
              unselectedLabelColor: Colors.white,
              labelColor: Colors.white),
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.lightBlue,
          accentColor: Colors.brown.shade700,
          primaryColorLight: Colors.lightBlue.shade100,
          dividerColor: Colors.brown,

          // Define the default font family.
          fontFamily: 'Georgia',

          /// An icon theme that contrasts with the card and canvas colors.
          iconTheme:
              new IconThemeData(color: Colors.brown, opacity: 1.0, size: 20.0),

          /// An icon theme that contrasts with the primary color.
          primaryIconTheme:
              new IconThemeData(color: Colors.white, opacity: 1.0, size: 20.0),

          accentIconTheme:
              new IconThemeData(color: Colors.brown, opacity: 1.0, size: 20.0),

          /// An icon theme that contrasts with the accent color.

          primaryTextTheme: TextTheme(
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
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Georgia'),
            //bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(),
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

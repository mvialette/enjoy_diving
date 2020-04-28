import 'package:flutter/material.dart';

import 'model/ApplicationModel.dart';
import 'incubator6/settings.dart';
import 'incubator6/spot_list.dart';
import 'incubator6/spot_detail.dart';

void main() => runApp(EnjoyDivingApp());

class EnjoyDivingApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    ApplicationModel applicationModel = new ApplicationModel(
      child: MaterialApp(
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
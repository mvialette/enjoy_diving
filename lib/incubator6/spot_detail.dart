import 'package:enjoy_diving/incubator6/detail/spot_detail_debug.dart';
import 'package:enjoy_diving/incubator6/detail/spot_detail_description.dart';
import 'package:enjoy_diving/incubator6/detail/spot_detail_informations.dart';
import 'package:enjoy_diving/incubator6/detail/spot_detail_location.dart';
import 'package:enjoy_diving/incubator6/detail/spot_detail_pictures.dart';
import 'package:flutter/material.dart';
import 'package:enjoy_diving/model/ApplicationModel.dart';
import 'package:enjoy_diving/model/Spot.dart';
import 'package:enjoy_diving/service/SpotService.dart';

import 'detail/spot_detail_historic.dart';
import 'detail/spot_detail_safety.dart';

class SpotDetailPage extends StatefulWidget {

  SpotService spotService = new SpotService();

  SpotDetailPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SpotDetailState(); //spot, fromLocation);
}

class SpotDetailState extends State<SpotDetailPage> with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(icon: Icon(Icons.bug_report), text: 'Debug',),
    Tab(icon: Icon(Icons.info), text: 'Résumé',),
    Tab(icon: Icon(Icons.description), text: 'Description',),
    Tab(icon: Icon(Icons.history), text: 'Historique'),
    Tab(icon: Icon(Icons.image), text: 'Images'),
    Tab(icon: Icon(Icons.location_on), text: 'Coordonnées'),
    Tab(icon: Icon(Icons.local_hospital), text: 'Sécurité'),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    final Spot spot = ApplicationModel.of(context).toSpot;
    final Map<String, double> fromLocation = ApplicationModel.of(context).fromLocation;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            spot.title,
            style: textTheme.title.copyWith(color: Colors.white),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: myTabs,
            isScrollable: true,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // TAB 1 : Debug
            SpotDetailDebug(),
            // TAB 2 : Informations
            SpotDetailInformations(),
            // TAB 3 : Description
            SpotDetailDescription(),
            // TAB 4 : history
            SpotDetailHistoric(),
            // TAB 5 : image
            SpotDetailPicitures(),
            // TAB 6 : location
            SpotDetailLocation(),
            // TAB 7 : evacuation / safety
            SpotDetailSafety(),
          ],
        ),
        /*
        floatingActionButton: FloatingActionButton(
          heroTag: 'nextSpotDetail',
          onPressed: () => _tabController.animateTo((_tabController.index + 1) % myTabs.length),
          child: Icon(Icons.arrow_right),
        ),
      */
    );
  }
}
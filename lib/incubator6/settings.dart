import 'package:flutter/material.dart';
import 'package:enjoy_diving/model/ApplicationModel.dart';
import 'package:enjoy_diving/model/Spot.dart';
import 'package:enjoy_diving/service/LocationController.dart';
import 'package:enjoy_diving/service/SpotService.dart';
import 'package:enjoy_diving/view/component/SliverBoxContent.dart';
import 'package:enjoy_diving/view/component/SliverGroupHeader.dart';
import 'package:package_info/package_info.dart';

class SettingsPage extends StatefulWidget {
  SpotService spotService = new SpotService();

  SettingsPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<SettingsPage> {
  final _formKey = GlobalKey<SettingsState>();

  // of the TextField.
  final myController = TextEditingController();

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    myController.text = ApplicationModel.of(context).boatSpeed.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.indigo,
      ),
      body: new FutureBuilder<List<Spot>>(
        future: widget.spotService.getAllStartSpotsFromJson(),
        builder: (BuildContext context, AsyncSnapshot<List<Spot>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred'),
            );
          } else {
            List<Spot> someSpots = snapshot.data;

            List<Widget> widgets = new List();

            widgets.add(new DropdownButton<Spot>(
              hint: Text('Choissez un spot'),
              value: ApplicationModel.of(context).fromSpot,
              items: someSpots.map((Spot spot) {
                return DropdownMenuItem<Spot>(
                  value: spot,
                  child: Text(spot.title),
                );
              }).toList(),
              onChanged: (Spot selectedSpot) {
                setState(() {
                  ApplicationModel.of(context).fromSpot = selectedSpot;
                  ApplicationModel.of(context).fromLocation['latitude'] =
                      selectedSpot.latitude;
                  ApplicationModel.of(context).fromLocation['longitude'] =
                      selectedSpot.longitude;
                  //Navigator.pop(context, selectedSpot);
                });
              },
            ));

            Form oneForm = Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widgets.toList(),
                ));

            CustomScrollView listView = CustomScrollView(slivers: <Widget>[
              SliverGroupHeader(header: 'Géolocalisation'),
              SliverBoxContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new SwitchListTile(
                      title: new Text(
                          'Activer la géolocalisation du périphérique : '),
                      value: isDeviceLocationEnable(context),
                      onChanged: (bool toggle) {
                        setState(() {
                          if (toggle == true) {
                            LocationController locationController =
                                new LocationController();
                            ApplicationModel.of(context).fromSpot = null;
                            locationController
                                .getCurrentLocationOfDevice()
                                .then((fromLocationOfTheDevice) {
                              ApplicationModel.of(context)
                                      .fromLocation['latitude'] =
                                  fromLocationOfTheDevice['latitude'];
                              ApplicationModel.of(context)
                                      .fromLocation['longitude'] =
                                  fromLocationOfTheDevice['longitude'];
                            });
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: new Text('No spots in this area found'),
                                    content: new Text('Selectionner un autre point de départ ou modifiez vos critères de recheche.'),
                                    actions: <Widget>[
                                      new FlatButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          child: new Text('Close')),
                                    ],
                                  );
                                }
                            );
                          } else {
                            ApplicationModel.of(context).fromSpot = null;
                            ApplicationModel.of(context).fromLocation.clear();
                          }
                        });
                      },
                    ),
                    Text(
                      "où alors, sélectionner un port ou un lieu de mise à l'eau parmis la liste accessible (pas besoin alors de géolocalisation) active :",
                    ),
                    oneForm,
                  ],
                ),
              ),
              SliverGroupHeader(header: 'Position'),
              SliverBoxContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'From location (used to calculate distance & time from this spot, to the diving available spots) : ',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'From latitude (decimal) : ${isLocationUndefined(context) ? 'N/A' : ApplicationModel.of(context).fromLocation['latitude']}',
                    ),
                    Text(
                      'From longitude (decimal) : ${isLocationUndefined(context) ? 'N/A' : ApplicationModel.of(context).fromLocation['longitude']}',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'From (WGS 84) : ${isLocationUndefined(context) ? 'N/A' : widget.spotService.getLocationsInWSG84(ApplicationModel.of(context).fromLocation['latitude'], ApplicationModel.of(context).fromLocation['longitude'])}',
                    ),
                  ],
                ),
              ),
              SliverGroupHeader(header: 'Navigation'),
              SliverBoxContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      "Quelle est la vitesse de votre navire ? (default 14 km/h)",
                    ),
                    TextField(
                      controller: myController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Vitesse ( km/h )',
                        prefixIcon: Icon(Icons.timer),
                      ),
                      keyboardType: TextInputType.number,
                      onSubmitted: (text) {
                        ApplicationModel.of(context).boatSpeed =
                            double.parse(text);
                      },
                    )
                  ],
                ),
              ),
              SliverGroupHeader(header: 'A propos'),
              SliverBoxContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        Text(
                          "Cette application est développée par Maxime VIALETTE.",
                        )
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        Text(
                          "App name : ",
                        ),
                        new Container(
                          height: 20.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade400
                          ),
                          child: Text(
                            _packageInfo.appName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        )
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        Text(
                          "Package name : ",
                        ),
                        new Container(
                          height: 20.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                              color: Colors.indigo.shade400
                          ),
                          child: Text(
                            _packageInfo.packageName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        Text(
                          "App version : ",
                        ),
                        new Container(
                          height: 20.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                              color: Colors.indigo.shade400
                          ),
                          child: Text(
                            _packageInfo.version,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        Text(
                          "Build number : ",
                        ),
                        new Container(
                          height: 20.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                              color: Colors.indigo.shade400
                          ),
                          child: Text(
                            _packageInfo.buildNumber,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ]);
            return listView;
          }
        },
      ),
    );
  }

  bool isDeviceLocationEnable(BuildContext context) {
    return ApplicationModel.of(context).fromSpot == null && !isLocationUndefined(context);
  }

  bool isLocationUndefined(BuildContext context) =>
      ApplicationModel.of(context).fromLocation == null ||
      ApplicationModel.of(context).fromLocation.length == 0;
}

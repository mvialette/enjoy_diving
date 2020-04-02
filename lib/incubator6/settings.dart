import 'package:flutter/material.dart';
import 'package:enjoy_diving/incubator6/ApplicationModel.dart';
import 'package:enjoy_diving/model/Spot.dart';
import 'package:enjoy_diving/service/LocationController.dart';
import 'package:enjoy_diving/service/SpotService.dart';
import 'package:enjoy_diving/view/component/SliverBoxContent.dart';
import 'package:enjoy_diving/view/component/SliverGroupHeader.dart';

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

  bool deviceLocationEnable = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
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
                  this.deviceLocationEnable = false;
                  ApplicationModel.of(context).fromSpot = selectedSpot;
                  ApplicationModel.of(context).fromLocation['latitude'] = selectedSpot.latitude;
                  ApplicationModel.of(context).fromLocation['longitude'] = selectedSpot.longitude;
                  //Navigator.pop(context, selectedSpot);
                });
              },
            ));

            Form oneForm = Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widgets.toList(),
                )
            );

            CustomScrollView listView = CustomScrollView(
                slivers: <Widget>[
                  SliverGroupHeader(header: 'Géolocalisation'),
                  SliverBoxContent(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /*
                        new ActionChip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.grey.shade800,
                              child: Icon(ApplicationModel.of(context).fromSpot == null ? Icons.check : Icons.close),
                            ),
                            label: Text('Géolocalisation'),
                            backgroundColor: ApplicationModel.of(context).fromSpot == null ? Colors.green : Colors.orange,
                            onPressed: () {
                              //setState(() {
                              setState(() {
                                //ApplicationModel.of(context).fromSpot = null;
                                LocationController locationController = new LocationController();

                                //Map<String, double> fromLocationOfTheDevice = locationController.getFromLocation();
                                locationController.getCurrentLocationOfDevice().then((fromLocationOfTheDevice) {
                                  ApplicationModel.of(context).fromSpot = null;
                                  ApplicationModel.of(context).fromLocation['latitude'] = fromLocationOfTheDevice['latitude'];
                                  ApplicationModel.of(context).fromLocation['longitude'] = fromLocationOfTheDevice['longitude'];
                                });
                                //Map<String, double> fromLocationOfTheDevice = locationController.getCurrentLocation();
                                //Map<String, double> fromLocationOfTheDevice = await locationController.getFromLocation();

                              });

                            }
                        ),*/
                        new SwitchListTile(
                          title: new Text('Activer la géolocalisation du périphérique : '),
                          value: this.deviceLocationEnable,
                          onChanged: (bool toggle) {
                            setState(() {
                              this.deviceLocationEnable = toggle;
                              if(this.deviceLocationEnable == true){
                                 LocationController locationController = new LocationController();
                                 ApplicationModel.of(context).fromSpot = null;
                                 locationController.getCurrentLocationOfDevice().then((fromLocationOfTheDevice) {

                                  ApplicationModel.of(context).fromLocation['latitude'] = fromLocationOfTheDevice['latitude'];
                                  ApplicationModel.of(context).fromLocation['longitude'] = fromLocationOfTheDevice['longitude'];
                                });
                              }else {
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
                          'From latitude (decimal) : ${isLocationDefined(context) ? 'N/A' : ApplicationModel.of(context).fromLocation['latitude']}',
                        ),
                        Text(
                          'From longitude (decimal) : ${isLocationDefined(context) ? 'N/A' : ApplicationModel.of(context).fromLocation['longitude']}',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'From (WGS 84) : ${isLocationDefined(context) ? 'N/A' : widget.spotService.getLocationsInWSG84(ApplicationModel.of(context).fromLocation['latitude'], ApplicationModel.of(context).fromLocation['longitude'])}',
                        ),
                      ],
                    ),
                  ),
                  SliverGroupHeader(header: 'A propos'),
                  SliverBoxContent(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Cette application est développée par Maxime VIALETTE.",
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

  bool isLocationDefined(BuildContext context) => ApplicationModel.of(context).fromLocation == null || ApplicationModel.of(context).fromLocation.length == 0;

  @override
  void initState() {
    super.initState();
  }
}





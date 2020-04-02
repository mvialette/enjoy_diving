import 'package:cached_network_image/cached_network_image.dart';
import 'package:enjoy_diving/incubator6/settings.dart';
import 'package:enjoy_diving/view/component/CustomSpotCard.dart';
import 'package:flutter/material.dart';
import 'package:enjoy_diving/incubator6/ApplicationModel.dart';
import 'package:enjoy_diving/model/Spot.dart';
import 'package:enjoy_diving/service/SpotService.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class SpotListPage  extends StatefulWidget {

  SpotService spotService = new SpotService();

  @override
  State<StatefulWidget> createState() => SpotListState();
}

class SpotListState extends State<SpotListPage> {

  final _formKey = GlobalKey<FormState>();

  bool displayModeList = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      /*
      drawer: Drawer5(),
      */
      drawer: new Drawer(
        child: new FutureBuilder<List<List<String>>>(
          future: widget.spotService.getSpotsDistinctedValuesFromJson(),
          builder: (BuildContext context, AsyncSnapshot<List<List<String>>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('An error occurred'),
              );
            } else {
              List<List<String>> spotDistinctedValues = snapshot.data;

              List<String> spotDistinctedPlaces = spotDistinctedValues[0];
              List<String> spotDistinctedKinds = spotDistinctedValues[1];

              Form oneForm = Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: getSearchFormWidgets(spotDistinctedPlaces, spotDistinctedKinds),
                  )
              );
              // ListView to allow form expandable area
              ListView listView = new ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  oneForm,
                ],
              );
              return listView;
            }
          },
        ),
      ),
      appBar: AppBar(
        title: Text('Enjoy Diving'),
        actions: <Widget>[
          IconButton(
            icon: Icon(displayModeList ? Icons.map : Icons.list),
            onPressed: () {
              setState(() {
                displayModeList = !displayModeList;
              });
            },
          ),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                _navigateAndDisplaySelection(context);
              },
          ),
        ],
      ),
      body: new FutureBuilder<List<Spot>>(
        future: widget.spotService.getSpotsByRechercheBean(context),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              // Display a circular progress indicator when no datas ar available
              //child: CircularProgressIndicator(),
              child: CustomSpotCard(
                  'Bienvenue dans l\'application "Dive Insights", pour découvrir les spots de plongées référencé, veuillez au-préalable vous rendre dans la page des paramètres de l\'application afin de la configurer. Bonne exploration.',
                  Colors.blue),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred'),
            );
          } else {
            String texte = '';
            if (ApplicationModel
                .of(context)
                .fromSpot != null) {
              texte = ApplicationModel
                  .of(context)
                  .fromSpot
                  .title;
            }
            return _SpotList(
              spots: snapshot.data.toList(),
              displayModeList: this.displayModeList,
            );
          }
        },
      ),
      /*
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            ApplicationModel.of(context).rechercheBean.deep0to20 = !ApplicationModel.of(context).rechercheBean.deep0to20;
          });
        },
      ),
      */
    );
  }

  _navigateAndDisplaySelection(BuildContext context) async {

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
    setState(() {
      this.displayModeList = this.displayModeList;
    });

  }

  List<Widget> getSearchFormWidgets(List<String> placeName,
      List<String> kinds) {
    List<Widget> resultSearchWidgets = new List();
    resultSearchWidgets.add(
        DrawerHeader(
            child:
            CachedNetworkImage(
              placeholder: (context, url) =>
                  Container(
                    color: Colors.blue,
                  ),
              imageUrl: 'https://jp-perroud.com/navig_8658_34.jpg',
              fit: BoxFit.cover,
            )
        )
    );

    // profondeur : 0-20, 20-40, 40-60
    resultSearchWidgets.add(ExpansionTile(
      title: Text('Profondeur', style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold
      )),
      //changeOnRedraw: false,
      children: <Widget>[
        new SwitchListTile(
          title: new Text('0-20 m'),
          value: ApplicationModel.of(context).rechercheBean.deep0to20,
          onChanged: (bool toggle) {
            setState(() {
              ApplicationModel.of(context).rechercheBean.deep0to20 = toggle;
            });
          },
        ),
        new SwitchListTile(
          title: new Text('20-40 m'),
          value: ApplicationModel.of(context).rechercheBean.deep20to40,
          onChanged: (bool toggle) {
            setState(() {
              ApplicationModel.of(context).rechercheBean.deep20to40 = toggle;
            });
          },
        ),
        new SwitchListTile(
          title: new Text('40-60 m'),
          value: ApplicationModel.of(context).rechercheBean.deep40to60,
          onChanged: (bool toggle) {
            setState(() {
              ApplicationModel.of(context).rechercheBean.deep40to60 = toggle;
            });
          },
        ),
        new SwitchListTile(
          title: new Text('60-70 m'),
          value: ApplicationModel.of(context).rechercheBean.deep60to70,
          onChanged: (bool toggle) {
            setState(() {
              ApplicationModel.of(context).rechercheBean.deep60to70 = toggle;
            });
          },
        ),
        new SwitchListTile(
          title: new Text('70-120 m'),
          value: ApplicationModel.of(context).rechercheBean.deep70to120,
          onChanged: (bool toggle) {
            setState(() {
              ApplicationModel.of(context).rechercheBean.deep70to120 = toggle;
            });
          },
        ),
      ],
    ));

    // the widgets for kind selection
    List<Widget> resultKindWidgets = new List();
    resultKindWidgets.add(new SwitchListTile(
      title: new Text('Toutes'),
      value: ApplicationModel.of(context).rechercheBean.kinds.containsAll(kinds),
      onChanged: (bool toggle) {
        setState(() {
          if (toggle == true) {
            ApplicationModel.of(context).rechercheBean.kinds.addAll(kinds);
          } else {
            ApplicationModel.of(context).rechercheBean.kinds.removeAll(kinds);
          }
        });
      },
    ));

    kinds.forEach((element) =>
      {
        resultKindWidgets.add(
            new SwitchListTile(
              title: new Text(element),
              value: ApplicationModel.of(context).rechercheBean.kinds.contains(element),
              //value: element != 'port' && ApplicationModel.of(context).rechercheBean.kinds.contains(element),

              onChanged: (bool toggle) {
                setState(() {
                  if (toggle == true) {
                    ApplicationModel.of(context).rechercheBean.addKind(element);
                  } else {
                    ApplicationModel.of(context).rechercheBean.removeKind(element);
                  }
                });
              },
            )
        )
      }
    );

    // zone : All available areas
    resultSearchWidgets.add(ExpansionTile(
        title: Text('Type', style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold
        )),
        children: resultKindWidgets)
    );

    // the widgets for area selection
    List<Widget> resultSearchPlaceWidgets = new List();
    resultSearchPlaceWidgets.add(new SwitchListTile(
      title: new Text('Toutes'),
      value: ApplicationModel.of(context).rechercheBean.places.containsAll(placeName),
      onChanged: (bool toggle) {
        setState(() {
          if (toggle == true) {
            ApplicationModel.of(context).rechercheBean.places.addAll(placeName);
          } else {
            ApplicationModel.of(context).rechercheBean.places.removeAll(placeName);
          }
        });
      },
    ));

    placeName.forEach((element) =>
      {
        resultSearchPlaceWidgets.add(
            new SwitchListTile(
              title: new Text(element),
              value: ApplicationModel.of(context).rechercheBean.places.contains(element),
              onChanged: (bool toggle) {
                setState(() {
                  if (toggle == true) {
                    ApplicationModel.of(context).rechercheBean.addPlace(element);
                  } else {
                    ApplicationModel.of(context).rechercheBean.removePlace(element);
                  }
                });
              },
            ))
      }
    );

    var _listDistanceType = ['Kilometers', 'Miles', 'Minutes'];

    // zone : All available areas
    resultSearchWidgets.add(ExpansionTile(
        title: Text('Zone', style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold
        )),
        children: resultSearchPlaceWidgets));

    // distance : km, miles marin, minutes + valeur (input type numerique)
    resultSearchWidgets.add(
        ExpansionTile(
          title: Text('Distance', style:
          TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold
          )
          ),
          children: <Widget>[
            new DropdownButton<String>(
              value: ApplicationModel.of(context).rechercheBean.distanceType,
              items: _listDistanceType.map((String dropDownMenuItem) {
                return DropdownMenuItem<String>(
                  value: dropDownMenuItem,
                  child: Text(dropDownMenuItem),
                );
              }).toList(),
              onChanged: (String distanceType) {
                setState(() {
                  ApplicationModel.of(context).rechercheBean.distanceType = distanceType;
                });
              },
            ),
            Text(ApplicationModel.of(context).rechercheBean.distanceValue.toInt().toString() + ' ' +
                ApplicationModel.of(context).rechercheBean.distanceType),
            Slider(
              value: ApplicationModel.of(context).rechercheBean.distanceValue,
              onChanged: (double distanceValue) {
                setState(() {
                  ApplicationModel.of(context).rechercheBean.distanceValue = distanceValue;
                });
              },
              divisions: 50,
              max: ApplicationModel.of(context).rechercheBean.maximumDistanceValue,
              min: 0,
            ),
          ],
        )
    );

    // the search button, at the bottom of the form
    resultSearchWidgets.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: RaisedButton(
            child: Text('Rechercher'),
            onPressed: () {
              // Validate returns true if the form is valid, or false
              // otherwise.
              if (_formKey.currentState != null && _formKey.currentState.validate()) {
                Navigator.pop(context);

                // show 10 spots on 130
                //Scaffold.of(context)
                //    .showSnackBar(SnackBar(content: Text("coucou")));
              }
            },
          ),
        )
    ));

    return resultSearchWidgets;
  }
}

class _SpotList extends StatelessWidget {
  _SpotList({
    Key key,
    @required this.spots,
    @required this.displayModeList,
  }) : super(key: key);

  final List<Spot> spots;
  final bool displayModeList;
  //final Map<String, double> fromLocation;

  @override
  Widget build(BuildContext context) {
    if(displayModeList){
      // this is the list mode
      return ListView.separated(
        itemCount: spots.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) => _SpotTile(
          spot: spots[index],
          //fromLocation : ApplicationModel.of(context).fromLocation,
        ),
      );
    }else{
      // this is the map mode
      //Text('Affichage mode carte : ${spots.length} items à afficher')
      List<Marker> spotsMarker = spots.map((spot) => new Marker(
        width: 30.0,
        height: 40.0,

        point: new LatLng(spot.latitude, spot.longitude),
        anchorPos: AnchorPos.align(AnchorAlign.top),
        builder: (context) => new Container(
          //alignment: Alignment(0.0, 1.0),
            /*
            decoration: BoxDecoration(
            //color: Colors.white12,
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),),
            */
          child:
            new IconButton(
              tooltip: 'Spot : ${spot.title}\r\nProf maxi : ${spot.deathLimit}m',
              padding: const EdgeInsets.all(0.0),//EdgeInsets.symmetric(vertical: 8.0),
              icon: spot.getIcon(ApplicationModel.of(context).fromLocation['latitude'], ApplicationModel.of(context).fromLocation['longitude']),
              color: spot.getIconColor(),
              iconSize: 30.0,

              onPressed: (){
                print('Marker (${spot.title}) tapped');
                ApplicationModel.of(context).toSpot = spot;
                Navigator.pushNamed(context, '/spotDetail');
              },
            )
          ),
      )).toList();

      double northMin = spots[0].latitude;
      double southMin = spots[0].latitude;

      double eastMin = spots[0].longitude;
      double westMin = spots[0].longitude;

      spots.forEach((spot){
        if(northMin < spot.latitude){
          northMin = spot.latitude;
        }

        if(southMin > spot.latitude){
          southMin = spot.latitude;
        }

        if(eastMin < spot.longitude){
          eastMin = spot.longitude;
        }

        if(westMin > spot.longitude){
          westMin = spot.longitude;
        }
      });

      print('Map Bounds, northMin=${northMin}, eastMin=${eastMin}, southMin=${southMin}, westMin=${westMin}');

      return new FlutterMap(
          options: new MapOptions(
            center: new LatLng(ApplicationModel.of(context).fromLocation['latitude'], ApplicationModel.of(context).fromLocation['longitude']),
            // define bound for South West
            swPanBoundary: LatLng(southMin, westMin),
            // define bound for North Eeat
            nePanBoundary: LatLng(northMin, eastMin),
            //map
            zoom: 11.0,
            minZoom: 6,
            //minZoom: 13.0,
          ),
          layers: [
            new TileLayerOptions(
              urlTemplate: "https://api.tiles.mapbox.com/v4/"
                  "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
              additionalOptions: {
                'accessToken': 'pk.eyJ1IjoiZ2lic29uNjkxMDAiLCJhIjoiY2p6cTIyaGZlMGIweDNuczFndmVhb3FidyJ9.9cUjPnmyDmsjmdj8xP2h8Q',
                'id': 'mapbox.streets',
                //'id': 'mapbox://styles/gibson69100/cjzq25j0t0giw1clhbfr4kj06',
              },
            ),
            /*
            // IMPLEMENTATION FOR OSM
            new TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c']
            ),
            */
            new MarkerLayerOptions(
                markers: spotsMarker,
          ),
        ]
      );
    }
      /*
      return ListView.separated(
        itemCount: spots.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: ((context, index) {
          //spot: spots[index];
          return ListTile(
            title: Text('${spots[index].title}'),
            subtitle: Text('${spots[index].longitude} / ${spots[index].latitude}'),
          );
        }),
      );
      */
      //return ;
  }
}

class _SpotTile extends StatefulWidget {

  _SpotTile({
    Key key,
    @required this.spot,
    //@required this.fromLocation,
  }) : super(key: key);

  final Spot spot;

  //Map<String, double> fromLocation;

  @override
  _SpotTileState createState() {
    return new _SpotTileState();
  }
}

class _SpotTileState extends State<_SpotTile> {

  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 100,
        height: 56,
        child: Hero(
          tag: 'image_${widget.spot.numid}',
          child: widget.spot.kind == 'port' ? Icon(Icons.directions_boat) : Icon(Icons.airplanemode_active),
          /* CachedNetworkImage(
            placeholder: (context, url) => Container(
              color: Colors.black12,
            ),
            imageUrl: widget.spot.pictures[0],
            fit: BoxFit.cover,
          ),
          */
        ),
      ),
      title: Hero(
        tag: 'title_${widget.spot.numid}',
        child: Text(
          widget.spot.title,
          style: Theme.of(context).textTheme.subhead,
        ),
      ),
      subtitle: Text(widget.spot.deathLimit.toString() + " m"),
      /*
      trailing: IconButton(
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        onPressed: () {
          setState(() {
            //isFavorite = !isFavorite;
          });
        },
      ),*/
      onTap: () {
        /*
        setState(() {
          ApplicationModel.of(context).toSpot = widget.spot;
        });*/
        ApplicationModel.of(context).toSpot = widget.spot;
        Navigator.pushNamed(context, '/spotDetail');
        //Scaffold.of(context).showSnackBar(SnackBar(content: Text("coucou")))
      },
      /*onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SpotDetailPage(
            spot: widget.spot,
            fromLocation: widget.fromLocation,
          ),
        ),
      ),*/
    );
  }
}
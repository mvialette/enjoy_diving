import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:enjoy_diving/incubator6/ApplicationModel.dart';

class Drawer5 extends StatefulWidget {
//class Drawer5 extends StatelessWidget {

  //List<String> maListe;


  @override
  State<StatefulWidget> createState() => Drawer5State();
}

class Drawer5State extends State<Drawer5>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
        child: new ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
        DrawerHeader(
        child:
        CachedNetworkImage(
        placeholder: (context, url) => Container(
      color: Colors.blue,
    ),
    imageUrl: 'https://jp-perroud.com/navig_8658_34.jpg',
    fit: BoxFit.cover,
    )
    ),
    ExpansionTile(
    title: Text('Profondeur ${ApplicationModel.of(context).fromLocation['latitude']}',
    style: TextStyle(
    color: Colors.black, fontWeight: FontWeight.bold
    )
    ),
    children: <Widget>[
    new SwitchListTile(
    title: new Text('0-20 m'),
    value: ApplicationModel.of(context).rechercheBean.deep0to20,
    onChanged: (bool toggle) {
      setState(() {
        ApplicationModel.of(context).rechercheBean.deep0to20 = !ApplicationModel.of(context).rechercheBean.deep0to20;
      });
    //setState(() {
    /*
    if(ApplicationModel.of(context).maListe.contains('Maxime')){
      ApplicationModel.of(context).maListe.remove('Maxime');
    }else{
      ApplicationModel.of(context).maListe.add('Maxime');
    }
    */
    //});
    },
    ),
    ],
    ),
    ],
    ),
    );
  }
}
import 'package:enjoy_diving/model/ApplicationModel.dart';
import 'package:enjoy_diving/service/SpotService.dart';
import 'package:flutter/material.dart';

class EditSpeedBoatPage extends StatefulWidget {
  SpotService spotService = new SpotService();

  EditSpeedBoatPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => EditSpeedBoatState();
}

class EditSpeedBoatState extends State<EditSpeedBoatPage> {
  final _boatSpeedFormKey = GlobalKey<FormState>();

  String _boatSpeed;

  // of the TextField.
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myController.text = ApplicationModel.of(context).boatSpeed.toString();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Speed Boat',
            style: Theme.of(context).textTheme.headline6,
          ),
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.save,
              ),
              onPressed: () {
                apply(context);
              },
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                  'Quelle est la vitesse de votre navire ? \nLa valeur initiale, (par default) est de 14 km/h.'),
              SizedBox(
                height: 20.0,
              ),
              Form(
                key: _boatSpeedFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Veuillez saisir une vitesse de navigation';
                        } else {
                          if (double.parse(text) > double.parse('50')) {
                            //TODO : regarder pour présenter correctement le message d'erreur
                            //return 'Etes vous réellement Superman ou Aquaman ?';
                            return 'Etes vous réellement Superman ou Aquaman ? \nVous devez uniquement rentrer une vitesse inférieur \nà 50 km/h.';
                          }
                        }
                        return null;
                      },
                      controller: myController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Vitesse ( km/h )',
                        prefixIcon: Icon(Icons.timer),
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (boatSpeed) => _boatSpeed = boatSpeed,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void apply(BuildContext context) {
    if (_boatSpeedFormKey.currentState.validate()) {
      _boatSpeedFormKey.currentState.save();
      ApplicationModel.of(context).boatSpeed = double.parse(_boatSpeed);
      print('New boat speed : $_boatSpeed');

      Navigator.pop(context,
          {'boatSpeedChanged': ApplicationModel.of(context).boatSpeed});
    } else {
      // TODO : passer en variable de state les données saisies en input du TextFormField
      print('ko');
    }
  }

  bool isDeviceLocationEnable(BuildContext context) {
    return ApplicationModel.of(context).fromSpot == null &&
        !isLocationUndefined(context);
  }

  bool isLocationUndefined(BuildContext context) =>
      ApplicationModel.of(context).fromLocation == null ||
      ApplicationModel.of(context).fromLocation.length == 0;
}

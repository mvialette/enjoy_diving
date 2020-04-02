import 'package:enjoy_diving/model/RechercheBean.dart';
import 'package:enjoy_diving/model/Spot.dart';
import 'package:flutter/material.dart';

class ApplicationModel extends InheritedModel<Map<String, double>> {

  final Map<String, double> fromLocation = new Map();

  Spot fromSpot;

  final RechercheBean rechercheBean = new RechercheBean();

  Spot toSpot;

  ApplicationModel({
    @required Widget child,
  }) : super(child: child);

  static ApplicationModel of(BuildContext context) {
    return InheritedModel.inheritFrom<ApplicationModel>(context);
  }

  @override
  bool updateShouldNotify(ApplicationModel old) {
    return fromLocation != old.fromLocation;
  }

  @override
  bool updateShouldNotifyDependent(InheritedModel<Map<String, double>> oldWidget, Set<Map<String, double>> dependencies) {
    return true;
  }
}
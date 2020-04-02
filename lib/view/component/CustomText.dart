import 'package:flutter/material.dart';

class CustomText extends Text {

  CustomText(String data, {TextStyle style}) : super(data == null || data.isEmpty ? 'Non renseigné' : data, style:style);
}
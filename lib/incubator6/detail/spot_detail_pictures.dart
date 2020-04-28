import 'package:cached_network_image/cached_network_image.dart';
import 'package:enjoy_diving/model/Spot.dart';
import 'package:enjoy_diving/service/SpotService.dart';
import 'package:flutter/material.dart';
import '../../model/ApplicationModel.dart';

class SpotDetailPicitures  extends StatelessWidget {

    SpotService spotService = new SpotService();

    @override
    Widget build(BuildContext context) {

        final Spot spot = ApplicationModel.of(context).toSpot;

        return ListView(
          children:
          spot.pictures
              .skip(1)
              .map((picture) => CachedNetworkImage(
            placeholder: (context, url) => Container(
              color: Colors.black12,
            ),
            imageUrl: picture,
            fit: BoxFit.cover,
          )).toList(),
        );
    }
}
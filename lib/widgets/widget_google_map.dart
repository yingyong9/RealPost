// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WidgetGoogleMap extends StatelessWidget {
  const WidgetGoogleMap({
    Key? key,
    required this.position,
  }) : super(key: key);

  final Position position;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 16,
      ),
      onMapCreated: (controller) {},
      markers: <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(position.latitude, position.longitude),
        ),
      ].toSet(),
    );
  }
}

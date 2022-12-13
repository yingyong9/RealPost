// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_collection_literals
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WidgetGoogleMap extends StatelessWidget {
  const WidgetGoogleMap({
    Key? key,
    required this.lat,
    required this.lng,
    this.zoom,
  }) : super(key: key);

  final double lat;
  final double lng;
  final double? zoom;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, lng),
        zoom: zoom ?? 16,
      ),
      onMapCreated: (controller) {},
      markers: <Marker>[
        Marker(
          markerId: const MarkerId('id'),
          position: LatLng(lat, lng),
          infoWindow: const InfoWindow(
              title: 'This is Title', snippet: 'This is snippet'),
        ),
      ].toSet(),
      // myLocationEnabled: true,
      zoomControlsEnabled: false,
      tiltGesturesEnabled: false,
    );
  }
}

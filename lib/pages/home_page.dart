import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_codigo5_maps/utils/map_style.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Set<Marker> _markers = {};

  Future<CameraPosition> initCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition();
    return CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 15,
    );
  }

  @override
  Widget build(BuildContext context) {
    initCurrentPosition();

    return Scaffold(
      body: FutureBuilder(
        future: initCurrentPosition(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.hasData) {
            return GoogleMap(
              initialCameraPosition: snap.data,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              compassEnabled: true,
              onMapCreated: (GoogleMapController googleController) {
                googleController.setMapStyle(jsonEncode(mapStyle));
              },
              markers: _markers,
              onTap: (LatLng position) {

                Marker marker = Marker(
                  markerId: MarkerId("00001"),
                  position: position
                );

                _markers.add(marker);

                setState((){});


              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

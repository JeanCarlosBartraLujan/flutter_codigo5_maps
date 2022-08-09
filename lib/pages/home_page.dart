import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatelessWidget {
  GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Future<CameraPosition> initCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition();
    return  CameraPosition(
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
        builder: (BuildContext context, AsyncSnapshot snap){
          if(snap.hasData){
            return GoogleMap(
              initialCameraPosition: snap.data,
              myLocationEnabled: true,
            );
          }
          return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}

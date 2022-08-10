import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_codigo5_maps/utils/map_style.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Set<Marker> _markers = {};


  List<Map<String, dynamic>> listLocation = [
    {
      "title": "Comisaria General",
      "phone": "986333222",
      "address": "Av. Lima 1234",
      "lat": -16.440428,
      "lon": -71.556919,
      "icon": "https://pngimg.com/uploads/police_badge/police_badge_PNG97.png",
    },
    {
      "title": "Estación de Bomberos",
      "phone": "986333222",
      "address": "Av. Lima 1234",
      "lat": -16.441953,
      "lon": -71.558851,
      "icon": "https://cdn-icons-png.flaticon.com/512/921/921079.png",
    },
    {
      "title": "Posta 1",
      "phone": "986333222",
      "address": "Av. Lima 1234",
      "lat": -16.445788,
      "lon": -71.556065,
      "icon": "https://cdn-icons-png.flaticon.com/512/4150/4150567.png",
    },
    {
      "title": "Central de Serenazgo",
      "phone": "986333222",
      "address": "Av. Lima 1234",
      "lat": -16.450554,
      "lon": -71.553889,
      "icon": "https://pngimg.com/uploads/police_badge/police_badge_PNG97.png",
    },
  ];


  Future<Uint8List> imageToBytes(String path, { int width = 100, bool fromNetwork = false }) async{

    late Uint8List bytes;

    if(fromNetwork){
      File file = await DefaultCacheManager().getSingleFile(path);
      bytes = await file.readAsBytes();
    }else{
      ByteData byteData = await rootBundle.load(path);
      bytes = byteData.buffer.asUint8List();
    }
    final codec = await ui.instantiateImageCodec(bytes, targetWidth: width);
    ui.FrameInfo frame =  await codec.getNextFrame();

    ByteData? myByteFormat =  await frame.image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return myByteFormat!.buffer.asUint8List();
  }






  Future<CameraPosition> initCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition();
    return CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 15,
    );
  }

  @override
  Widget build(BuildContext context) {


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
              onTap: (LatLng position)  async{

                MarkerId markerId = MarkerId(_markers.length.toString());
                Marker marker = Marker(
                  markerId: markerId,
                  // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                  //icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/icons/location-icon.png'),
                  icon: BitmapDescriptor.fromBytes(await imageToBytes("https://cdn-icons-png.flaticon.com/512/921/921079.png")),
                  position: position,
                  rotation: -4,
                  draggable: true,
                  onDrag: (LatLng newPosition){
                    print(newPosition);
                  },
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

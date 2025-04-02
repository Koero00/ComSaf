import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

LocationSettings locationSettings = LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 100);

// Getting our current location (not live)
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if(!serviceEnabled){
    return Future.error('Location services disabled');
  }

  permission = await Geolocator.checkPermission();
  if(permission == LocationPermission.denied){
    permission = await Geolocator.requestPermission();
    if(permission== LocationPermission.denied){
      return Future.error('Location permissions are denied');
    }
  }
  
  if(permission == LocationPermission.deniedForever){
    return Future.error(
      "Location permission are permanently denied, we cannot request permission"
    );
  }

  Position pos =  await Geolocator.getCurrentPosition(locationSettings: locationSettings);
  
  
  return pos;
}


StreamSubscription<Position> posStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
  (Position? pos) {
    print(pos == null ? 'Unknown' : pos.latitude.toString());
  }
);

class _HomeScreenState extends State<HomeScreen> {
  double lat = 51.4613462;
  double long = 5.5000914;
  
  void initPos() async{
    Position pos = await _determinePosition();
    print('${pos.latitude} ${pos.longitude}');
    setState(() {
      lat = pos.latitude;
      long = pos.latitude;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPos();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(lat, long),
            initialZoom: 16,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
          ]
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // Flexible for screen
                  width: MediaQuery.sizeOf(context).width * 0.50,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 177, 177, 177),
                        blurRadius: 10,
                        offset: Offset(0,5)
                      )
                    ]
                  ),
                  
                  child: Row(
                    children: [
                      Icon(Icons.search, color: const Color.fromARGB(255, 55, 57, 79),),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Find a contact",
                            border: InputBorder.none
                          ),
                        ) 
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: (){

                  }, 
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                    elevation: 12,
                    shadowColor: Color.fromARGB(255, 177, 177, 177),
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: Color.fromARGB(255, 55, 57, 79),
                    size: 28,
                    ),
                )
              ],
            ),

            
          ),
        )
      ],
    );
  }
}
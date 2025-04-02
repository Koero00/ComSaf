// home.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) toggleSOS;
  final bool isSOSActive;

  const HomeScreen({super.key, required this.toggleSOS, required this.isSOSActive});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

LocationSettings locationSettings = LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 100);

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services disabled');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error("Location permission are permanently denied, we cannot request permission");
  }

  Position pos = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
  return pos;
}

class _HomeScreenState extends State<HomeScreen> {
  double lat = 51.4613462;
  double long = 5.5000914;
  int countdown = 10;
  Timer? _timer;

  void initPos() async {
    Position pos = await _determinePosition();
    setState(() {
      lat = pos.latitude;
      long = pos.longitude;
    });
  }

  @override
  void initState() {
    super.initState();
    initPos();
  }

  void startCountdown() {
    _timer?.cancel();
    countdown = 10;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() => countdown--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSOSActive && _timer == null) {
      startCountdown();
    } else if (!widget.isSOSActive) {
      _timer?.cancel();
      _timer = null;
    }
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
          ],
        ),
        widget.isSOSActive
            ? Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: widget.isSOSActive ? 560 : 0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)
                    ],
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("SOS Activated", style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      countdown > 0
                          ? Column(
                              children: [
                                Text("Stress signal sent in:", style: TextStyle(fontSize: 36)),
                                SizedBox(height: 10),
                                Text("$countdown", style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.red)),
                              ],
                            )
                          : Text("Help is on their way!", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 0, 0))),
                    ],
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}

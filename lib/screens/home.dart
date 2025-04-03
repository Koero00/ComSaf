import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool, bool, bool) toggleSOS;
  final bool isSOSActive;
  final bool isSafe;
  final bool isCrisisAverted;

  const HomeScreen({
    super.key, 
    required this.toggleSOS, 
    required this.isSOSActive, 
    required this.isSafe,
    required this.isCrisisAverted
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double lat = 51.4613462;
  double long = 5.5000914;
  int countdown = 10;
  Timer? _timer;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _stopwatchTimer;

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
    _stopwatch.reset();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown > 1) {
        setState(() => countdown--);
      } else {
        timer.cancel();
        setState(() {
          countdown = 0;
          _stopwatch.start();
          _startStopwatchTimer();
          // Change to SAFE state automatically when countdown ends
          widget.toggleSOS(true, true, false);
        });
      }
    });
  }

  void _startStopwatchTimer() {
    _stopwatchTimer?.cancel();
    _stopwatchTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_stopwatch.isRunning) {
        setState(() {});
      }
    });
  }

  // Reset the state when SOS is deactivated completely
  void resetState() {
    _timer?.cancel();
    _stopwatchTimer?.cancel();
    _timer = null;
    _stopwatch.stop();
    _stopwatch.reset();
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // If crisis averted is signaled while stopwatch is running, stop it
    if (widget.isCrisisAverted && _stopwatch.isRunning) {
      _stopwatch.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handle SOS activation
    if (widget.isSOSActive && _timer == null && !widget.isCrisisAverted) {
      startCountdown();
    } else if (!widget.isSOSActive) {
      resetState();
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
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)],
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.isCrisisAverted ? "Crisis averted" : "SOS Activated", 
                        style: TextStyle(
                          fontSize: 44, 
                          fontWeight: FontWeight.bold,
                          color: widget.isCrisisAverted ? Colors.green : Colors.black
                        )
                      ),
                      SizedBox(height: 10),
                      if (countdown > 0)
                        Column(
                          children: [
                            Text("Stress signal sent in:", style: TextStyle(fontSize: 36)),
                            SizedBox(height: 10),
                            Text(
                              "$countdown",
                              style: TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 20), // Spacing before button
                            TextButton(
                              onPressed: null, // Decorative button, no functionality
                              style: TextButton.styleFrom(
                                backgroundColor: Color(0xFF37394F), // Button color
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30), // Rounded corners
                                ),
                              ),
                              child: Text(
                                "Notify contacts only",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // White text
                                ),
                              ),
                            ),
                          ],
                        )
                      else if (widget.isCrisisAverted)
                        Container() // No additional text when crisis is averted
                      else
                        Column(
                          children: [
                            Text("Help is on their way!", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black)),
                            SizedBox(height: 10),
                            Text("Elapsed Time: ${_stopwatch.elapsed.inSeconds} sec", style: TextStyle(fontSize: 22, color: Colors.black)),
                          ],
                        ),
                    ],
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return Future.error('Location services disabled');

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return Future.error('Location permissions are denied');
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error("Location permission is permanently denied, we cannot request permission");
  }

  return await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 100));
}

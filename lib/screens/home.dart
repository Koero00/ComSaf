import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helpin/widget/aidcard.dart';
import 'package:helpin/widget/expansiontile.dart';
import 'package:helpin/widget/topbar.dart';
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


  // For the rescuer view
  bool hasAcceptedSOS = false;
  bool medicalTabOpen = true;

  int distance = 168;
  int age = 38;
  String name = "Frank Morris";
  String medicalSituation = "Asthma";
  String medicalDescr = "luctus faucibus nibh, vitae dignissim orci imperdiet vitae. Maecenas euismod, nunc ac pharetra blandit, libero diam blandit magna, nec semper enim nunc vel ipsum. Fusce pretium mauris ac felis lobortis, ac varius velit porttitor. Nunc gravida est felis, id tempor sapien lacinia id. Nullam maximus nec orci et pharetra. Suspendisse lacinia, mi quis ultricies placerat, nulla ligula tincidunt ex, commodo pellentesque dui est in elit. Proin a dui pulvinar metus vehicula iaculis. Nam ut erat vel tortor mollis ultricies vehicula sit amet diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Vivamus placerat turpis quis massa pharetra luctus. Proin feugiat euismod ante sit amet ullamcorper. Cras aliquam finibus pellentesque. Vestibulum lobortis enim ut laoreet molestie. Mauris a sapien tempor, egestas urna in, interdum nulla. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Lorem ipsum dolor sit amet, consectetur adipiscing elit";



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

  // Format elapsed time as mm:ss
  String formatElapsedTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "$minutes:${remainingSeconds.toString().padLeft(2, '0')}";
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

        TopSearchBar(),
        // Bottom slider
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
                  child: 
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: hasAcceptedSOS ? 
                        // Container which is switchable (for rescue view)
                        Container(
                          // alignment: Alignment.topCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: MediaQuery.sizeOf(context).height * 0.05,),
                              // Buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: 
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                          color: Color.fromRGBO(55, 57, 79, 1),
                                          width: 1
                                        ),
                                        backgroundColor: medicalTabOpen ? Color.fromRGBO(55, 57, 79, 1) : Color.fromRGBO(255, 255, 255, 1),
                                        foregroundColor: medicalTabOpen ? Color.fromRGBO(255, 255, 255, 1) : Color.fromRGBO(55, 57, 79, 1)
                                      ),
                                      onPressed: (){
                                        setState(() => medicalTabOpen = !medicalTabOpen);
                                      }, 
                                      child: Text("Emergency Info")
                                    ),
                                  ),

                                  SizedBox(width: MediaQuery.sizeOf(context).width * 0.6),

                                  Expanded(
                                    child: 
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: medicalTabOpen ? Color.fromRGBO(255, 255, 255, 1) : Color.fromRGBO(55, 57, 79, 1),
                                        foregroundColor: medicalTabOpen ? Color.fromRGBO(55, 57, 79, 1) : Color.fromRGBO(255, 255, 255, 1),
                                        side: BorderSide(
                                          color: Color.fromRGBO(55, 57, 79, 1),
                                          width: 1
                                        ),
                                      ),
                                      onPressed: (){
                                        setState(() => medicalTabOpen = !medicalTabOpen);
                                      }, 
                                      child: Text("Assistance")
                                    ),
                                  )
                                ],
                              ),

                              SizedBox(height: 66),

                              medicalTabOpen ? Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(radius: 54,),
                                      SizedBox(width: 12,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            // Name and age
                                            Text(name, style: TextStyle(fontSize: 25),),
                                            Text("Age: $age", style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                      Spacer(),
                                      // Distance to 
                                      Text("${distance}m", style: TextStyle(fontSize: 14),)
                                    ],
                                  ),

                                  SizedBox(height: 20,),

                                  Row(
                                    children: [
                                      Icon(Icons.monitor_heart_rounded, color: Colors.red,),
                                      SizedBox(width: 8,),
                                      // Title of health condition
                                      Text(medicalSituation, style: TextStyle(fontSize: 16))
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  // Health description
                                  Text(
                                    medicalDescr,
                                  ),

                                  SizedBox(height: 20,),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: 
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            side: BorderSide(
                                              color: Color.fromRGBO(55, 57, 79, 1),
                                              width: 1
                                            ),
                                            backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                                            foregroundColor: Color.fromRGBO(55, 57, 79, 1)
                                          ),
                                          onPressed: (){

                                          }, 
                                          child: Text("Can't help now")
                                        ),
                                      ),

                                      SizedBox(width: MediaQuery.sizeOf(context).width * 0.2),

                                      Expanded(
                                        child: 
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromRGBO(55, 57, 79, 1),
                                            foregroundColor: Color.fromRGBO(255, 255, 255, 1),
                                            
                                          ),
                                          onPressed: (){}, 
                                          child: Text("Accept")
                                        ),
                                      )

                                    ],
                                  )

                                ],
                              )
                              :
                              // Medical Assistance tab
                              Column(
                                children: [
                                  // Collapsable titles etc
                                  CusExpansiontile(title: "First AID instructions", child: [
                                    SizedBox(height: 10,),
                                    AidCard(
                                      stepCounter: 1, 
                                      aidDescrip: "Nam luctus faucibus nibh, vitae dignissim orci imperdiet vitae. Maecenas euismod, nunc ac pharetra blandit, libero diam blandit magna, nec semper enim nunc vel ipsum. Fusce pretium mauris ac felis lobortis, ac varius velit porttitor. Nunc gravida est felis, id tempor sapien lacinia id. Nullam maximus nec orci et pharetra. Suspendisse lacinia, mi quis ultricies placerat, nulla ligula tincidunt ex, commodo pellentesque dui est in elit. Proin a dui pulvinar metus vehicula iaculis. Nam ut erat vel tortor mollis ultricies vehicula sit amet diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Vivamus placerat turpis quis massa pharetra luctus. Proin feugiat euismod ante sit amet ullamcorper. Cras aliquam finibus pellentesque. Vestibulum lobortis enim ut laoreet molestie. Mauris a sapien tempor, egestas urna in, interdum nulla. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Lorem ipsum dolor sit amet, consectetur adipiscing elit."
                                    ),
                                    AidCard(
                                      stepCounter: 2, 
                                      aidDescrip: "Nam luctus faucibus nibh, vitae dignissim orci imperdiet vitae. Maecenas euismod, nunc ac pharetra blandit, libero diam blandit magna, nec semper enim nunc vel ipsum. Fusce pretium mauris ac felis lobortis, ac varius velit porttitor. Nunc gravida est felis, id tempor sapien lacinia id. Nullam maximus nec orci et pharetra. Suspendisse lacinia, mi quis ultricies placerat, nulla ligula tincidunt ex, commodo pellentesque dui est in elit. Proin a dui pulvinar metus vehicula iaculis. Nam ut erat vel tortor mollis ultricies vehicula sit amet diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Vivamus placerat turpis quis massa pharetra luctus. Proin feugiat euismod ante sit amet ullamcorper. Cras aliquam finibus pellentesque. Vestibulum lobortis enim ut laoreet molestie. Mauris a sapien tempor, egestas urna in, interdum nulla. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Lorem ipsum dolor sit amet, consectetur adipiscing elit."
                                    ),
                                    SizedBox(height: 10,),
                                  ],),
                                  
                                  SizedBox(height: 16,),

                                  CusExpansiontile(title: "AI Assistance", child: [

                                  ],),

                                ],
                              ),


                            ],
                          ),
                        )
                        :
                        Container(
                            child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
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
                                      padding: EdgeInsets.symmetric(horizontal: 46, vertical: 20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30), // Rounded corners
                                      ),
                                    ),
                                    child: Text(
                                      "Notify contacts only",
                                      style: TextStyle(
                                        fontSize: 18,
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
                                  Text(
                                    "Elapsed Time: ${formatElapsedTime(_stopwatch.elapsed.inSeconds)}",
                                    style: TextStyle(fontSize: 22, color: Colors.black),
                                  ),
                                ],
                              ),
                          ],
                          )
                          
                        )
                      ,
                    )
                  
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

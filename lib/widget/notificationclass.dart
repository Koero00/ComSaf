import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationFB {

  double lat = 0;
  double long = 0;

  double get latitude => lat;
  double get longitude => long;


  set latitude(double lati){
    lat = lati;  
  }

  set longitude(double longi){
    long = longi;
  }

  // Token handling (bit confusing)
  Future<void> saveFcmToken(String userId) async{

    final user = FirebaseAuth.instance.currentUser;

    if(user == null){
      print('No user signed in');
      return;
    }

    final token = await FirebaseMessaging.instance.getToken();

    if(token == null){
      print("unable to get token");
      return;
    }
    await FirebaseFirestore.instance.collection('users').doc(userId)
    .set({
      'fcmToken':token
    }, SetOptions(merge: true));

    return;
  }

  // Sending a notification
  Future<void> sendLocationNotification({
    required String senderId,
    required String receiverId, 
    required double lat,
    required double lon,
  }) async {
    final HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('sendLocationNotification');

    try {
      final result = await callable.call({
        'senderId': senderId,
        'receiverId': receiverId,
        'lat': lat,
        'long': lon,
      });

      print("Notification sent successfully: ${result.data}");
    } on FirebaseFunctionsException catch (e) {
      print("Cloud Function Error: ${e.code} - ${e.message}");
    } catch (e) {
      print("Unexpected error: $e");
    }
  }

  // Receiving notifications
  void setupFcmHandlers(){
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      print("Heyo we received a msg: ${msg.data}");
      latitude = msg.data['lat'];
      longitude = msg.data['long'];
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg){
      print("User tapped notification from background");

    });

    FirebaseMessaging.instance.getInitialMessage().then((msg) {
      if(msg != null){
        print("Notification caused app launch?");
      }
    });
  }
}
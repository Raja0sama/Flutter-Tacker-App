import 'dart:async';
import 'global.dart' as global;

import 'package:flutter/material.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:tracker/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';


void main() {
  startFGS();
}



void startFGS() async {

  //necessity of editMode is dubious (see function comments)
  await ForegroundService.notification.startEditMode();

  await ForegroundService.notification.setTitle("Tracker 🚗♥");
  await ForegroundService.notification 
      .setText("Tracker Service is Running on the Foregroun ");

  await ForegroundService.notification.finishEditMode();

  await ForegroundService.startForegroundService(foregroundServiceFunction);
  await ForegroundService.getWakeLock();
}
Geolocator geolocator = Geolocator();
  Position userLocation;

void foregroundServiceFunction() async{
print(global.id);
//   geolocator
//     .getPositionStream(LocationOptions(
//         accuracy: LocationAccuracy.bestForNavigation, timeInterval: 1000))
//     .listen((position) {
      
//       print('Lat : '+position.latitude.toString() + "\n Lng : "+position.longitude.toString());
// });

}

   Future<Position> _getLocation() async {
    var currentLocation;
    try {
          currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  
  @override
  _MyAppState createState() => _MyAppState(userId);
}


class _MyAppState extends State<HomePage> {
  String _appMessage = "";
  
Geolocator geolocator = Geolocator();

Position userLocation;
  var id ;
  _MyAppState(this.id);

  @override
  void initState() {
    super.initState();
      global.id = id;

    // _toggleForegroundServiceOnOff();
  }
  

  void _toggleForegroundServiceOnOff() async {
    final fgsIsRunning = await ForegroundService.foregroundServiceIsStarted();
    String appMessage;

    if (fgsIsRunning) {
      await ForegroundService.stopForegroundService();
      appMessage = "Stopped foreground service.";
    } else {
      startFGS();
      appMessage = "Started foreground service.";
    }

    setState(() {
      _appMessage = appMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
            child: Column(
          children: <Widget>[
            Text('YOU ARE BEING TRACKED',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Padding(padding: EdgeInsets.all(8.0)),
            Text(_appMessage, style: TextStyle(fontStyle: FontStyle.italic)),
            RaisedButton(
              child: Text('Start / Stop '),
              onPressed: _toggleForegroundServiceOnOff,
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        )),
      ),
    );
  }

   Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
}

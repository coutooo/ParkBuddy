import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parkbuddy/Screens/Profile/profile_page.dart';
import 'package:parkbuddy/Screens/park_page.dart';
import 'package:parkbuddy/Screens/pedometer/pedometer_page.dart';
import 'package:parkbuddy/Screens/scan_page.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:flutter/foundation.dart' as foundation;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _scanned = "wait";

  @override
  void initState() {
    super.initState();
    listenSensor();
    setBrightness(1);
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  late StreamSubscription<dynamic> _streamSubscription;

  // definir brilho
  Future<void> setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to set brightness';
    }
  }

  Future<void> resetBrightness() async {
    try {
      await ScreenBrightness().resetScreenBrightness();
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to reset brightness';
    }
  }

  // ler sensor proximidade
  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      debugPrint(event.toString());
      if (event > 0) {
        setBrightness(0);
      } else {
        setBrightness(1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        backgroundColor: Color.fromRGBO(160, 5, 10, 40),
        automaticallyImplyLeading: false, // tirar o botao de andar para trás
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Transform.scale(
                scale: 0.75,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Image(
                    image: AssetImage(
                      'assets/images/logo-no-background.png',
                    ),
                  ),
                ),
              ),

              // park card
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => ParkPage())));
                },
                child: Card(
                  elevation: 10,
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(50),
                      ),
                      Icon(
                        Icons.car_crash,
                        size: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Park',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // share card
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => ScanScreen())));
                  //scanQR();
                },
                child: Card(
                  elevation: 10,
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(50),
                      ),
                      Icon(
                        Icons.qr_code_2,
                        size: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Scan QR',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Statistics card
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => PedPage())));
                },
                child: Card(
                  elevation: 10,
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(50),
                      ),
                      Icon(
                        Icons.directions_walk,
                        size: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Statistics',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Definicoes card
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => ProfilePage())));
                },
                child: Card(
                  elevation: 10,
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(50),
                      ),
                      Icon(
                        Icons.settings,
                        size: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

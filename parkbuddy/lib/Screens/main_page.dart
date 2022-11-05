import 'package:flutter/material.dart';
import 'package:parkbuddy/Screens/Profile/profile_page.dart';
import 'package:parkbuddy/Screens/park_page.dart';
import 'package:parkbuddy/Screens/pedometer/pedometer_page.dart';
import 'package:parkbuddy/Screens/qr_map.dart';
import 'package:parkbuddy/Screens/qr_page.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:barcode_widget/barcode_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late double _latitude;
  late double _longitude;

  String scanned = "wait";

  Future<void> scanQR() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#6a0dad", "Cancel", true, ScanMode.QR);
      print('TESTEEEEEEEEEE   -> ' + barcodeScanRes);
      final split = barcodeScanRes.split(' ');
      setState(() {
        scanned = barcodeScanRes;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => MapSample2(
                      carLat: double.parse(split[0]),
                      carLong: double.parse(split[1]),
                    ))));
      });
      // });
    } catch (e) {
      setState(() {
        scanned = "unable to read the qr";
      });
    }
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
                child: Image(
                  image: AssetImage(
                    'assets/images/logo-no-background.png',
                  ),
                ),
              ),
              SizedBox(
                height: 75,
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
                  scanQR();
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

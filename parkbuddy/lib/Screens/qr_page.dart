import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:parkbuddy/Screens/qr_map.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  String qrString = "";

  final _myBox = Hive.box('mybox2');

  late double _latitude;
  late double _longitude;

  String scanned = "wait";

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    setState(() {
      _latitude = double.parse(_myBox.get(0).latitude);
      _longitude = double.parse(_myBox.get(0).longitude);
      qrString = _myBox.getAt(0).latitude +
          " " +
          _myBox.getAt(0).longitude +
          " " +
          _myBox.getAt(0).street;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(160, 5, 10, 40),
        title: Text("Share"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // qr code
          BarcodeWidget(
            color: Colors.black,
            data: qrString,
            height: 250,
            width: 250,
            barcode: Barcode.qrCode(),
          ),
          ElevatedButton(
            onPressed: () {
              scanQR();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Color.fromRGBO(160, 5, 10, 40), // Background color
              foregroundColor: Colors.white, // Text Color (Foreground color)
            ),
            child: Text("Scan QR"),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }

  Future<void> scanQR() async {
    //print("entrei");
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#6a0dad", "Cancel", true, ScanMode.QR);
      setState(() {
        scanned = barcodeScanRes;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => MapSample2(
                      carLat: _latitude,
                      carLong: _longitude,
                    ))));
      });
      // });
    } catch (e) {
      setState(() {
        scanned = "unable to read the qr";
      });
    }
  }

  Future<void> getUserScannedData() async {}
}

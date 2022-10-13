import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  String qrString = "ParkBuddy QRCODE hello prof";

  String scanned = "wait";

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    setState(() {
      //qrString = sp.getString("user_id")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(160, 5, 10, 40),
        title: Text("Generate QR Code"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // qr code
          BarcodeWidget(
            color: Color.fromRGBO(160, 5, 10, 40),
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
        getUserScannedData();
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

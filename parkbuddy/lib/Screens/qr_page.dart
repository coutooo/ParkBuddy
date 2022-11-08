import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

class CreateScreen extends StatefulWidget {
  final double carLat;
  final double carLong;

  const CreateScreen({Key? key, required this.carLat, required this.carLong})
      : super(key: key);
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  String qrString = "";

  static late double carLong;
  static late double carLat;

  @override
  void initState() {
    carLat = widget.carLat;
    carLong = widget.carLong;
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    setState(() {
      qrString = carLat.toString() + " " + carLong.toString();
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
          SizedBox(
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }
}

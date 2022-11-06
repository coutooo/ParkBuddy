import 'dart:ffi';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:parkbuddy/Screens/map.dart';
import 'package:parkbuddy/Screens/qr_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';

import 'package:hive_flutter/hive_flutter.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final _myBox = Hive.box('mybox2');

  var carImage;
  late double _latitude;
  late double _longitude;
  var _address;
  var _indexCar;

  @override
  void initState() {
    super.initState();
    setState(() {
      _indexCar = getCarIndex();
      carImage = getCarPref();
    });
  }

  Future<int> getCarIndex() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'action' key. If it doesn't exist, returns null.
    _indexCar = prefs.getInt('index');

    return _indexCar;
  }

  Future<Image> getCarPref() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    carImage = _myBox.get(_indexCar).icon;

    _latitude = double.parse(_myBox.get(_indexCar).latitude);
    _longitude = double.parse(_myBox.get(_indexCar).longitude);
    print(_latitude.toString() + "asdasda");

    if (carImage == null) {
      return Image.asset(
          'assets/images/blackcar.png'); // talvez mudar esta imagem (imagem de quanto nao se tira foto ao  carro)
    } else {
      return Image.asset(carImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Info"),
        backgroundColor: Color.fromRGBO(160, 5, 10, 40),
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(70, 20, 70, 0),
              child: FutureBuilder(
                future: getCarPref(),
                builder: (BuildContext context, AsyncSnapshot<Image> image) {
                  if (image.hasData && carImage != null) {
                    print(carImage);
                    return Image.file(
                      File(carImage),
                      width: 400,
                    ); // image is ready
                  } else {
                    return new Image.asset(
                        'assets/images/blackcar.png'); // placeholder  assets/images/blackcar.png'
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Localization",
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
            FutureBuilder<int>(
                future: getCarIndex(),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData) {
                    return Text("" + _myBox.get(_indexCar).street);
                  } else {
                    return Text("loading...");
                  }
                }),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
              child: SizedBox(
                height: 30,
                width: 300,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(160, 5, 10, 40)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => MapSample(
                                    carLat: _latitude,
                                    carLong: _longitude,
                                  ))));
                    },
                    child: Text("CHECK MAP")),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 30,
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(160, 5, 10, 40)),
                onPressed: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => CreateScreen(
                                carLat: _latitude,
                                carLong: _longitude,
                              ))));
                }),
                child: Text(
                  "Share",
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 30,
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(160, 5, 10, 40)),
                onPressed: (() {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Address'),
                      content: Text("" + _myBox.get(_indexCar).address),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("OK"))
                      ],
                    ),
                  );
                }),
                child: Text(
                  "MORE INFO",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

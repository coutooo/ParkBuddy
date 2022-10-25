import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  var carImage;
  var pos;
  @override
  void initState() {
    super.initState();
    pos = _determinePosition();
    print(pos.latitude.toString() + "posicaooooooooo");
    print("entreiiiiii");
    print(carImage.toString() + "carrrimageeeeeeee");
    setState(() {
      print(carImage.toString() + "22222222");
      carImage = getCarPref();
    });
  }

  Future<Image> getCarPref() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'action' key. If it doesn't exist, returns null.
    carImage = prefs.getString('imagePath');
    print("carImageeee" + carImage.toString());

    return Image.asset(carImage);
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Park"),
        backgroundColor: Color.fromRGBO(160, 5, 10, 40),
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(70, 20, 70, 0),
            child: FutureBuilder(
              future: getCarPref(),
              builder: (BuildContext context, AsyncSnapshot<Image> image) {
                if (image.hasData && carImage != null) {
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
            width: 200,
          ),
          Text(
            "Localization",
            style: TextStyle(
                fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

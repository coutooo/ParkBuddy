import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  var carImage;

  @override
  void initState() {
    super.initState();
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
            width: 100,
          ),
          Text("Localization"),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoPage extends StatefulWidget {
  final String icon;
  const InfoPage(this.icon, {Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  var carImage;

  @override
  void initState() {
    super.initState();
    print("entreiiiiii");
    setState(() {
      carImage = getCarPref();
    });
  }

  Future<Image> getCarPref() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'action' key. If it doesn't exist, returns null.
    carImage = prefs.getString('imagePath');
    print("carImageeee" + carImage);

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
        body: FutureBuilder(
          future: getCarPref(),
          builder: (BuildContext context, AsyncSnapshot<Image> image) {
            if (image.hasData) {
              return Image.asset(carImage); // image is ready
            } else {
              return new Container(); // placeholder
            }
          },
        ));
  }
}

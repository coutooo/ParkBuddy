import 'package:flutter/material.dart';
import 'package:parkbuddy/Screens/pedometer/pedometer_page.dart';
import 'package:parkbuddy/Screens/qr_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        backgroundColor: Color.fromRGBO(160, 5, 10, 40),
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
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
                //clique do park
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
                    MaterialPageRoute(builder: ((context) => CreateScreen())));
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
                      'Share',
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
                //settings button
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
                      Icons.settings,
                      size: 40,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'More',
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
    );
  }
}

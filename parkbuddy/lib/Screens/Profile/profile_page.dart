import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../Welcome/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final _histBox = Hive.box('hist_box');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Color.fromRGBO(160, 5, 10, 40),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => LoginPage())));
            },
          )
        ],
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: width * 0.8,
                  height: height * 0.28,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double inHeight = constraints.maxHeight;
                      double inWidth = constraints.maxWidth;
                      return Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: inHeight * 0.65,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 80,
                                  ),
                                  DefaultTextStyle(
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                    ),
                                    child: AnimatedTextKit(
                                      animatedTexts: [
                                        WavyAnimatedText('Hi Buddy!'),
                                        WavyAnimatedText(
                                            'Hope you find your car :)'),
                                      ],
                                      isRepeatingAnimation: true,
                                      onTap: () {
                                        print("Tap Event");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage: AssetImage(
                                  'assets/images/logo-white.png',
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'History',
                          style: TextStyle(
                            color: Color.fromRGBO(160, 5, 10, 40),
                            fontSize: 27,
                            fontFamily: 'Nunito',
                          ),
                        ),
                        Divider(
                          thickness: 2.5,
                        ),
                        ListView.separated(
                          itemBuilder: (ctx, index) {
                            int reverseIndex = _histBox.length - 1 - index;
                            print(_histBox.get(reverseIndex));
                            final item =
                                _histBox.getAt(reverseIndex).split('ç');
                            return Container(
                              height: height * 0.15,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    item[0],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    "Matricula: " + item[1],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    "Carro: " + item[2],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, reverseIndex) =>
                              Divider(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _histBox == null
                              ? 0
                              : (_histBox.length > 4
                                  ? 4
                                  : _histBox.length), //_histBox.length,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

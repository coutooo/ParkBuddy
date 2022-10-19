import 'package:flutter/material.dart';

class ParkPage extends StatefulWidget {
  const ParkPage({Key? key}) : super(key: key);

  @override
  State<ParkPage> createState() => _ParkPageState();
}

class _ParkPageState extends State<ParkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Park"),
        backgroundColor: Color.fromRGBO(160, 5, 10, 40),
      ),
      backgroundColor: Colors.grey[300],
      //body:
    );
  }
}

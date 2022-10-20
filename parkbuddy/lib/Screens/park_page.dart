import 'package:flutter/material.dart';
import 'package:parkbuddy/models/carRepo.dart';
import 'package:parkbuddy/models/car_dialog.dart';

class ParkPage extends StatefulWidget {
  const ParkPage({Key? key}) : super(key: key);

  @override
  State<ParkPage> createState() => _ParkPageState();
}

class _ParkPageState extends State<ParkPage> {
  @override
  Widget build(BuildContext context) {
    final cars = CarRepos.cars;

    void showCarDialog() {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: AddCarDialog(),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          );
        },
      );
    }

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(160, 5, 10, 40),
          onPressed: () {
            showCarDialog();
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text("Park"),
          backgroundColor: Color.fromRGBO(160, 5, 10, 40),
        ),
        backgroundColor: Colors.grey[300],
        body: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.separated(
              itemBuilder: (BuildContext context, int pos) {
                return ListTile(
                  leading: Image.asset(cars[pos].icon),
                  title: Text(cars[pos].name),
                  trailing: Text(cars[pos].localization),
                );
              },
              padding: EdgeInsets.all(16),
              separatorBuilder: (_, __) => Divider(),
              itemCount: cars.length),
        ));
  }
}

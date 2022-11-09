import 'package:flutter/material.dart';
import 'package:parkbuddy/Screens/info_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:parkbuddy/models/car_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cars.dart';

class ParkPage extends StatefulWidget {
  const ParkPage({Key? key}) : super(key: key);

  @override
  State<ParkPage> createState() => _ParkPageState();
}

class _ParkPageState extends State<ParkPage> {
  //reference created box

  final _myBox = Hive.box('mybox2');
  final _histBox = Hive.box('hist_box');

  //write data to db
  void writeData(Car car) {
    print(_myBox.length);
    _myBox.put(_myBox.length, car);

    _histBox.add(car.street + "ç" + car.matricula + "ç" + car.name);
  }

  //Delete data from db
  void deleteData(int index) {
    _myBox.delete(index);
  }

  @override
  Widget build(BuildContext context) {
    void addCarData(Car car) {
      setState(() {
        writeData(car);
      });
    }

    void showCarDialog() {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: AddCarDialog(addCarData),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          );
        },
      );
    }

    Future<void> setCarPref(index) async {
      // Obtain shared preferences.
      final prefs = await SharedPreferences.getInstance();
      // Save an integer value to 'counter' key.
      if (index != null) {
        await prefs.setInt('index', index);
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(160, 5, 10, 40),
        onPressed: () {
          print(_myBox.length.toString() + "leng");
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
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            final item = _myBox.getAt(index);
            final int indexKey = item.key;
            return Dismissible(
              key: Key(item
                  .matricula), // matricula nao pode ser repetida se nao da erro
              background: Container(color: Colors.black38),
              onDismissed: (direction) {
                setState(() {
                  print(_myBox.length.toString() + "leng");
                  deleteData(indexKey);
                });
              },
              child: InkWell(
                onTap: () {
                  setCarPref(indexKey); // _myBox.get(index).icon
                  // fazer pagina onde se vai ver as fotos e assim  Image.asset(carList[index].icon)
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => InfoPage())));
                },
                child: Card(
                    margin: EdgeInsets.all(4),
                    elevation: 8,
                    child: ListTile(
                      leading: Text(
                        _myBox.get(indexKey).name,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w400),
                      ),
                      title: Text(
                        _myBox.get(indexKey).street,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w400),
                      ),
                      subtitle: Text(
                        _myBox.get(indexKey).matricula,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black12,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
              ),
            );
          },
          itemCount: _myBox.length,
        ),
      ),
    );
  }
}

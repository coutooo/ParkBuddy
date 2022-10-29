import 'package:flutter/material.dart';
import 'package:parkbuddy/Screens/info_page.dart';
import 'package:parkbuddy/models/carRepo.dart';
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

  final _myBox = Hive.box('mybox');

  //write data to db
  void writeData(Car car) {
    print(_myBox.length);
    _myBox.put(_myBox.length, car);
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

    Future<void> setCarPref(path) async {
      // Obtain shared preferences.
      final prefs = await SharedPreferences.getInstance();
      // Save an integer value to 'counter' key.
      if (path != null) {
        await prefs.setString('imagePath', path);
      }
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
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            final item = _myBox.get(index);
            return Dismissible(
              key: Key(item.matricula),
              background: Container(color: Colors.black38),
              onDismissed: (direction) {
                setState(() {
                  deleteData(index);
                });
              },
              child: InkWell(
                onTap: () {
                  setCarPref(_myBox.get(index).icon);
                  // fazer pagina onde se vai ver as fotos e assim  Image.asset(carList[index].icon)
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => InfoPage())));
                },
                child: Card(
                    margin: EdgeInsets.all(4),
                    elevation: 8,
                    child: ListTile(
                      leading: Text(
                        _myBox.get(index).name,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w400),
                      ),
                      title: Text(
                        _myBox.get(index).localization,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w400),
                      ),
                      subtitle: Text(
                        _myBox.get(index).matricula,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black12,
                            fontWeight: FontWeight.w400),
                      ),
                      /*trailing: Text(
                        carList[index].icon,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black26,
                            fontWeight: FontWeight.w400),
                      ), // mudar isto ver embaixo*/
                    )),
              ),
            );
          },
          itemCount: _myBox.length,
        ),
      ),
    );
  }

  /*ListView.separated(
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
              */
}

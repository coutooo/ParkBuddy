import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skeletons/skeletons.dart';
import 'cars.dart';
import 'package:path/path.dart';

class AddCarDialog extends StatefulWidget {
  final Function(Car) addCar;

  AddCarDialog(this.addCar);

  @override
  State<AddCarDialog> createState() => _AddCarDialogState();
}

class _AddCarDialogState extends State<AddCarDialog> {
  late bool _isLoading;
  var _latitude;
  var _longitude;
  var _address;
  var _street;

  var freeplate = true;

  var nameController = TextEditingController();
  var plateController = TextEditingController();

  Future<void> _updatePosition() async {
    Position pos = await _determinePosition();
    List<Placemark> pm =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);

    _latitude = pos.latitude.toString();
    _longitude = pos.longitude.toString();
    _address = pm[0];
    _street = "";
    if (_address.administrativeArea != null) {
      _street = _address.administrativeArea;
    }
    if (_address.subAdministrativeArea != null) {
      _street = _street + ", " + _address.subAdministrativeArea;
    }
    if (_address.street != null)
      _street = _street + "\nStreet: " + _address.street;
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
  void initState() {
    _isLoading = true;
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
    _updatePosition();
  }

  //reference created box
  final _myBox = Hive.box('mybox2');

  //write data
  void writeData(Car car) {
    _myBox.put(1, car);
    print(_myBox.get(1));
  }

  File? _image;

  Future getImage(var tmp1, var tmp2) async {
    nameController = tmp1;
    plateController = tmp2;
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      //final imageTemporary = File(image.path);

      final imageTemporary = await saveFilePermanently(image.path);

      setState(() {
        this._image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File> saveFilePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    Widget buildTextfield(String hint, TextEditingController controller) {
      return Container(
        margin: EdgeInsets.all(4),
        child: TextField(
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(160, 5, 10, 40))),
            labelText: hint,
            labelStyle: TextStyle(color: Colors.black38),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black38),
            ),
          ),
          controller: controller,
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(8),
      height: 350,
      width: 400,
      child: SingleChildScrollView(
        child: Skeleton(
          isLoading: _isLoading,
          skeleton: Container(
              child: LoadingAnimationWidget.horizontalRotatingDots(
                  color: Color.fromRGBO(160, 5, 10, 40), size: 80)),
          child: Column(
            children: [
              Text(
                "Add Car",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Color.fromRGBO(160, 5, 10, 40),
                ),
              ),

              // https://youtu.be/IePaAGXzmtU?t=1   <- image picker
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(160, 5, 10, 40),
                  ),
                  onPressed: () {
                    var tmp1 = nameController;
                    var tmp2 = plateController;
                    getImage(tmp1, tmp2);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.image_outlined),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Take a picture')
                    ],
                  )),
              //buildTextfield('assets/images/blackcar.png', iconController),
              buildTextfield(
                'Car',
                nameController,
              ),
              buildTextfield('Car Plate', plateController),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(160, 5, 10, 40)),
                onPressed: () {
                  final car = Car(
                      icon: _image != null ? _image!.path : null,
                      name: nameController.text,
                      address: _address.toString(),
                      street: _street.toString(),
                      matricula: plateController.text,
                      latitude: _latitude.toString(),
                      longitude: _longitude.toString());

                  for (int i = 0; i < _myBox.length; i++) {
                    if (_myBox.getAt(i).matricula.toString() ==
                        plateController.text) {
                      freeplate = false;
                    }
                  }
                  print(freeplate.toString() + "freeplate");
                  if (freeplate == true) {
                    widget.addCar(car);
                    Navigator.of(context).pop();
                  }
                  if (freeplate == false) {
                    freeplate = true;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("This plate is already in use!"),
                      backgroundColor: Colors.black,
                    ));
                  }
                },
                child: Text("Add Car"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

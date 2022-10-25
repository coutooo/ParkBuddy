import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'cars.dart';
import 'package:path/path.dart';

class AddCarDialog extends StatefulWidget {
  final Function(Car) addCar;

  AddCarDialog(this.addCar);

  @override
  State<AddCarDialog> createState() => _AddCarDialogState();
}

class _AddCarDialogState extends State<AddCarDialog> {
  File? _image;

  Future getImage() async {
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

    var iconController = TextEditingController();
    var nameController = TextEditingController();
    var localController = TextEditingController();
    var plateController = TextEditingController();

    return Container(
      padding: EdgeInsets.all(8),
      height: 350,
      width: 400,
      child: SingleChildScrollView(
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
                  getImage();
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
            buildTextfield('Place', localController),
            buildTextfield('Car Plate', plateController),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(160, 5, 10, 40)),
              onPressed: () {
                final car = Car(
                    icon: _image != null ? _image!.path : null,
                    name: nameController.text,
                    localization: localController.text,
                    matricula: plateController.text);

                widget.addCar(car);
                Navigator.of(context).pop();
              },
              child: Text("Add Car"),
            ),
          ],
        ),
      ),
    );
  }
}

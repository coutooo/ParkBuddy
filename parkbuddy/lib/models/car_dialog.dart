import 'package:flutter/material.dart';

class AddCarDialog extends StatefulWidget {
  const AddCarDialog({Key? key}) : super(key: key);

  @override
  State<AddCarDialog> createState() => _AddCarDialogState();
}

class _AddCarDialogState extends State<AddCarDialog> {
  @override
  Widget build(BuildContext context) {
    Widget buildTextfield(String hint, TextEditingController controller) {
      return Container(
        margin: EdgeInsets.all(4),
        child: TextField(
          decoration: InputDecoration(
            labelText: hint,
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
            buildTextfield('assets/images/blackcar.png', iconController),
            buildTextfield('Car', nameController),
            buildTextfield('Aveiro', localController),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(160, 5, 10, 40)),
              onPressed: () {},
              child: Text("Add Car"),
            ),

            // vou aqui https://youtu.be/t3sRreruhYQ?t=1278
          ],
        ),
      ),
    );
  }
}

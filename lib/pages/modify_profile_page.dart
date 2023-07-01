// ignore_for_file: file_names, prefer_const_constructors, camel_case_types

import 'package:flutter/material.dart';

class ModifyProfilePage extends StatefulWidget {
  const ModifyProfilePage({super.key});

  static const String pageRoute = '/modify_profile';

  @override
  State<ModifyProfilePage> createState() => _ModifyProfilePage_State();
}

class _ModifyProfilePage_State extends State<ModifyProfilePage> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Tonino');
  final TextEditingController _descrController =
      TextEditingController(text: 'Antonio \nPrencipe \n2004');

  saveData() {
    String newName = _nameController.text;
    String newDescr = _descrController.text;

    //save new data

    //return to profile page
    Navigator.pushReplacementNamed(context, '/profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //remove arrow back
        // automaticallyImplyLeading: false,
        elevation: 1,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Modifica profilo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Inserire nome',
                      ),
                    ),
                    TextField(
                      maxLines: 4,
                      controller: _descrController,
                      decoration: InputDecoration(
                        labelText: 'Inserire descrizione',
                      ),
                    ),
                    // CalendarDatePicker(
                    //     initialDate: DateTime(2023),
                    //     firstDate: DateTime(2000),
                    //     lastDate: DateTime(2023),
                    //     onDateChanged: (DateTime) {}),
                    // TextField(
                    //   keyboardType: TextInputType.number,
                    //   decoration: InputDecoration(labelText: 'Inserire età'),
                    // ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.check),
                        label: Text('Salva'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

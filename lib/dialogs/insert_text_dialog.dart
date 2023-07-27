import 'package:flutter/material.dart';

textDialog(BuildContext context, TextEditingController controller) async {
  // TextEditingController _textEditingController = TextEditingController();
  controller.text = '';
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  Widget cancelButton = TextButton(
    child: const Text("CANCEL"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Inserisci il nuovo commento'),
        content: TextField(
          controller: controller,
        ),
        actions: [okButton, cancelButton],
      );
    },
  );
}

import 'package:flutter/material.dart';

oneButtonDialog(BuildContext context, String text) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(text),
    // content: Text("This is my message."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

twoButtonDialog(context, text) async {
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.of(context).pop(true);
    },
  );

  Widget cancelButton = TextButton(
    child: const Text("CANCEL"),
    onPressed: () {
      Navigator.of(context).pop(false);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(text),
    // content: Text("This is my message."),
    actions: [
      okButton,
      cancelButton
    ],
  );

  // show the dialog
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

import 'package:flutter/material.dart';

class PostSettingsPopup extends StatefulWidget {
  const PostSettingsPopup({super.key});

  @override
  State<PostSettingsPopup> createState() => _PostSettingsPopupState();
}

class _PostSettingsPopupState extends State<PostSettingsPopup> {
  String? selectedMenu;
  double appBarHeight = AppBar().preferredSize.height;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        offset: Offset(
          0.0, appBarHeight
        ),
        // Callback that sets the selected popup menu item.
        onSelected: (item) {
          setState(() {
            selectedMenu = item;
          });
          print(selectedMenu);
        },
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem(
              child: Text("Condividi"),
              value: '/hello',
            ),
            const PopupMenuItem(
              child: Text("Elimina"),
              value: '/about',
            ),
            const PopupMenuItem(
              child: Text("Contact"),
              value: '/contact',
            )
          ];
        });
  }
}

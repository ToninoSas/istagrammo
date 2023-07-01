// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:instagram_app/utils/func.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key, required this.selectedIndex});

  int selectedIndex;

  @override
  State<BottomNavBar> createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  @override
  BottomNavigationBar build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
      onTap: (_index) {
        setState(() {
          widget.selectedIndex = _index;
        });
        teleport(context, widget.selectedIndex);
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey[350],
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        // BottomNavigationBarItem(icon: Icon(Icons.tv_rounded), label: 'Reels'),
        // BottomNavigationBarItem(icon: Icon(Icons.shop_outlined), label: 'Shop'),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle), label: 'Profile')
      ],
    );
  }
}

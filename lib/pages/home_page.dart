// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:instagram_app/utils/func.dart';

import 'package:instagram_app/widgets/circle_box_widget.dart';
import 'package:instagram_app/widgets/bottom_navbar_widget.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

// import 'package:instagram_app/func.dart';

class MyHomePage extends StatefulWidget {
  static const String pageRoute = '/home';

  const MyHomePage({super.key});

  // final User currentUser;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = routes['home']!;

  // String name = "ToninoSas";

  @override
  Widget build(BuildContext context) {
    // User user = UserDataServiceProvider.of(context).userData;

    AuthUser user = Provider.of<UserProvider>(context).userProfile;

    return Scaffold(
        appBar: AppBar(
          //remove arrow back
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Instagram'),
          actions: <Widget>[
            IconButton(
                onPressed: () => {},
                icon: const Icon(Icons.add_a_photo_rounded)),
            IconButton(onPressed: () => {}, icon: const Icon(Icons.favorite)),
            IconButton(
                onPressed: () => {}, icon: const Icon(Icons.send_rounded)),
          ],
        ),
        body: Container(
            child: Column(children: <Widget>[
          //body
          Expanded(
              child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              if (index == 0) {
                //story viewer
                return Column(
                  children: [
                    const Divider(
                      height: 2,
                      thickness: 2,
                    ),
                    Container(
                        color: Theme.of(context).primaryColor,
                        height: 90,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: List.generate(10, (int index) {
                              return CircleBox(
                                imageProvider: AssetImage("images/img1.jpg"),
                              );
                            }))),
                    const Divider(
                      height: 0,
                      thickness: 2,
                    ),
                  ],
                );
              }
              // return PostWidget(userPostName: user.username);
              return Container();
            },
          ))
        ])),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: selectedIndex,
        ));
  }
}

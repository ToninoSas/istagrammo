// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app_cool/providers/user_provider.dart';
import 'package:instagram_app_cool/widgets/post_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  int selectedIndex = 0;
  static const pageRouteName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Instagram'),
          actions: const [
            IconButton(onPressed: null, icon: Icon(Icons.favorite)),
            IconButton(onPressed: null, icon: Icon(Icons.send_rounded)),
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Non ci sono posts ora. Riprova più tardi'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return PostCard(snap: snapshot.data!.docs[index].data());
                  },
                );
              }

              return const CircularProgressIndicator();
            })

        // bottomNavigationBar: hasLoadedData
        //     ? BottomNavBar(selectedIndex: widget.selectedIndex)
        //     : null);
        );
  }
}

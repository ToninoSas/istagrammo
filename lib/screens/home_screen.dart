// ignore_for_file: must_be_immutable

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:istagrammo/providers/theme_provider.dart';
import 'package:istagrammo/utils/styles.dart';
import 'package:istagrammo/widgets/pick_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  int selectedIndex = 0;
  static const pageRouteName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedValue = 0;
  final ScrollController _scrollController = ScrollController();

  void scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    // _scrollController.jumpTo(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Provider.of<ThemeProvider>(context).isDarkTheme ?
              darkTheme.scaffoldBackgroundColor : lightTheme.scaffoldBackgroundColor,
            title: Text('Istagrammo'),

          ),
          body: StreamBuilder(
              // stream: _selectedValue == 0
              //     ? FirebaseFirestore.instance
              //         .collection(DatabaseMethods.postsCollection)
              //         .orderBy('datePublished', descending: true)
              //         // .where('isTwitt', isEqualTo: false)
              //         .snapshots()
              //     : FirebaseFirestore.instance
              //         .collection(DatabaseMethods.postsCollection)
              //         .orderBy('nLikes', descending: true)
              //         // .where('isTwitt', isEqualTo: false)
              //         .snapshots(),
              stream: Supabase.instance.client
                  .from('posts')
                  .stream(primaryKey: ["id"]).eq(
                      'codUtente', Supabase.instance.client.auth.currentUser!.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // if (snapshot.data!.isEmpty) {
                  //   return const Center(
                  //     child: Text('Non ci sono picks ora. Riprova più tardi'),
                  //   );
                  // }
                  return Center(child: Text("i tuoi posts"),);
                  // return ListView.builder(
                  //   controller: _scrollController,
                  //   itemCount: snapshot.data!.length,
                  //   itemBuilder: (context, index) {
                  //     // if (snapshot.data!.docs[index].data()['isTwitt']) {
                  //     //   return TwittCard(snap: snapshot.data!.docs[index].data());
                  //     // } else {
                  //     //   return PostCard(snap: snapshot.data!.docs[index].data());
                  //     // }
                  //     return PickWidget();
                  //   },
                  // );
                }
      
                return const Center(
                  child: CircularProgressIndicator(),
                );
              })
          ),
    );
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:istagrammo/resources/auth_methods.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:istagrammo/models/pick.dart';
import 'package:istagrammo/models/user.dart';

class UserProvider extends ChangeNotifier {
  MyUser? _myUser;
  MyUser get myUser => _myUser!;

  bool hasLoaded = false;

  final supabase = Supabase.instance.client;

  User? currentUser = Supabase.instance.client.auth.currentUser;

  UserProvider() {
    init();

  }


  StreamSubscription postsListener(){
    return supabase
        .from('posts')
        .stream(primaryKey: ["id"])
        .eq('codUtente', currentUser!.id)
        .listen((data) async {
      hasLoaded = false;
      if (_myUser == null) return;

      _myUser!.posts = [];

      for (var pick in data) {
        Post mypost = Post.fromSnap(pick);
        _myUser!.posts.add(mypost);
      }

      hasLoaded = true;

      //aggiorno gli ascoltatori
      notifyListeners();
    });
  }
  followersListener(){
     return supabase
        .from('seguiti')
        .stream(primaryKey: ['codUtente', 'codSeguito'])
        .eq('codSeguito', currentUser!.id)
        .listen((data) async {
      // if (_myUser == null) return;
      _myUser!.followers = [];
      for (var follower in data) {
        final followerData = await supabase
            .from('users')
            .select('*')
            .eq('id', follower['codUtente'])
            .single();

        _myUser!.followers.add(MyUser.fromSnap(followerData));
        print(MyUser.fromSnap(followerData).toJson());
      }
      notifyListeners();
    });
  }
  seguitiListener(){
     return supabase
        .from('seguiti')
        .stream(primaryKey: ['codUtente', 'codSeguito'])
        .eq('codUtente', currentUser!.id)
        .listen((data) async {
      // if (_myUser == null) return;
      _myUser!.followed = [];
      for (var seguito in data) {
        final seguitoData = await supabase
            .from('users')
            .select('*')
            .eq('id', seguito['codSeguito'])
            .single();

        _myUser!.followed.add(MyUser.fromSnap(seguitoData));
      }
      notifyListeners();
    });
  }

  init() {
    StreamSubscription? _postsStream;
    StreamSubscription? _followersStream;
    StreamSubscription? _seguitiStream;
    supabase
        .from('users')
        .stream(primaryKey: ['id'])
        .eq('id', currentUser!.id)
        .listen((data) async{

          print("ho aggiornato il mio user");

          _myUser = MyUser.fromSnap(data.first);
          hasLoaded = true;
          notifyListeners();

          // se ci sono dei listener precedenti, li cancello, altrimenti ascolto a doppio l'evento
          _postsStream?.cancel();
          _followersStream?.cancel();
          _seguitiStream?.cancel();

          // una volta cancellati li posso ricreare
          _postsStream = postsListener();
          _followersStream = followersListener();
          _seguitiStream = seguitiListener();
    } );

    // AuthMethods().getUserData(uid: currentUser!.id).then((value){
    //   _myUser = value;
    //   hasLoaded=true;
    //   notifyListeners();
    //
    //   postsListener();
    //   followersListener();
    //   seguitiListener();
    // });
  }
}

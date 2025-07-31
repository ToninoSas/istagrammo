import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final _auth = Supabase.instance.client.auth;
  final _storage = Supabase.instance.client.storage;

  Future<String> uploadProfilePic(Uint8List file) async {
    return await _uploadImageToStorage('profileImgs', file, false);
  }

  Future<String> uploadPost(Uint8List file) async {
    return await _uploadImageToStorage('picks', file, true);
  }

  // adding image to firebase storage
  Future<String> _uploadImageToStorage(
      String folder, Uint8List file, bool isPost) async {
    // creating location to our firebase storage

    String filename, filepath;
    if (isPost) {
      String id = const Uuid().v1();
      filename = id;
    } else {
      filename = _auth.currentUser!.id;
    }

    filepath = "$folder/$filename";
    try {
      await _storage.from('bucket1').uploadBinary(folder, file);

      String downloadUrl =
          await _storage.from('bucket1').getPublicUrl(filepath);
      return downloadUrl;
    } catch (e) {
      print("Errore durante l'upload: $e");
      return e.toString();
    }
  }
}

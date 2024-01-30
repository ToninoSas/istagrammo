// ignore_for_file: unnecessary_import

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


showSnackBar(BuildContext context, String msg) {
  FocusScope.of(context).unfocus();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

Future<Uint8List?> getImageFromGallery() async {
  XFile? pickedFile =
      (await ImagePicker().pickImage(source: ImageSource.gallery));

  if (pickedFile != null) {
    return _cropImage(pickedFile);
  }

  return null;
}

Future<Uint8List?> _cropImage(XFile image) async {
  CroppedFile? croppedImage = await ImageCropper().cropImage(
    sourcePath: image.path,
    aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    compressQuality: 100,
    maxHeight: 500,
    maxWidth: 500,
    compressFormat: ImageCompressFormat.jpg,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Modifica l\'immagine',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: true,
      )
    ],
  );

  if (croppedImage != null) {
    return croppedImage.readAsBytes();
  }

  return null;
}

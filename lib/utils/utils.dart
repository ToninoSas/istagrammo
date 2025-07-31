// ignore_for_file: unnecessary_import

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

String defaultProfileImg =
    "https://static.vecteezy.com/system/resources/previews/020/911/740/original/user-profile-icon-profile-avatar-user-icon-male-icon-face-icon-profile-icon-free-png.png";

showSnackBar(BuildContext context, String msg) {
  FocusScope.of(context).unfocus();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}



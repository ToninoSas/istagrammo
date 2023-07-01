import 'package:flutter/material.dart';

class CircleBox extends StatelessWidget {
   CircleBox({super.key, required this.imageProvider, this.width =80, this.height = 80});

  // final String imgPath;
  final ImageProvider imageProvider;
  final int width, height;
  //immagine della storia
  //bordo colorato

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width.toDouble(),
        height: height.toDouble(),
        margin: const EdgeInsets.all(7),
        decoration: BoxDecoration(
            border: const Border(
                top: BorderSide(width: 1, color: Colors.grey),
                left: BorderSide(width: 1, color: Colors.grey),
                right: BorderSide(width: 1, color: Colors.grey),
                bottom: BorderSide(width: 1, color: Colors.grey)),
            shape: BoxShape.circle,
            color: Colors.white,
            image: DecorationImage(image: imageProvider)));
  }
}

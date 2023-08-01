import 'package:flutter/material.dart';

class CircleBox extends StatelessWidget {
   CircleBox({super.key, required this.imageProvider, this.radius =40});

  // final String imgPath;
  final ImageProvider imageProvider;
  final double radius;
  //immagine della storia
  //bordo colorato

  @override
  Widget build(BuildContext context) {
    // return Container(
    //     width: width.toDouble(),
    //     height: height.toDouble(),
    //     margin: const EdgeInsets.all(7),
    //     decoration: BoxDecoration(
    //         border: const Border(
    //             top: BorderSide(width: 1, color: Colors.grey),
    //             left: BorderSide(width: 1, color: Colors.grey),
    //             right: BorderSide(width: 1, color: Colors.grey),
    //             bottom: BorderSide(width: 1, color: Colors.grey)),
    //         shape: BoxShape.circle,
    //         color: Colors.white,
    //         image: DecorationImage(image: imageProvider)));

    return Container(
      margin: EdgeInsets.all(6),
      child: CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider
              ),
    );
  }
}

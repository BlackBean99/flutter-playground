import 'package:flutter/material.dart';

class ImageData extends StatelessWidget {
  String icon;
  final double? width;

  ImageData(this.icon,{super.key, this.width=55,}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(icon, width:,)
  }
}
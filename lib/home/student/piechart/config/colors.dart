// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AppColors {
  static Color primaryWhite = Color(0xFFCADCED);
  // static Color primaryWhite = Colors.indigo[100];

  static List pieColors = [
    Color.fromARGB(255, 241, 149, 180),
    Color.fromARGB(255, 241, 151, 123),
    Color.fromARGB(255, 207, 200, 200),
    Color.fromARGB(255, 157, 241, 160),
    Color.fromARGB(255, 243, 212, 118),
    Color.fromARGB(255, 241, 151, 123),
    Color.fromARGB(255, 207, 200, 200),
    Color.fromARGB(255, 201, 123, 214),
  ];
  static List<BoxShadow> neumorpShadow = [
    BoxShadow(
        color: Colors.white.withOpacity(0.5),
        spreadRadius: -5,
        offset: Offset(-5, -5),
        blurRadius: 30),
    BoxShadow(
        color: Colors.grey.withOpacity(0.3),
        spreadRadius: 2,
        offset: Offset(7, 7),
        blurRadius: 20)
  ];
}

const kBackgroundColor = Color.fromRGBO(33, 33, 33, 1);
const kBackBantuColor = Color(0xFFF2F2F2);
const kActiveIconColor = Color(0xFF404040);
const kTextColor = Color(0xFFD9D9D9);
const kSubColor = Color(0xFF8C8C8C);
const kBlueLightColor = Color(0xFFC7B8F5);
const kBlueColor = Color(0xFF817DC0);
const kShadowColor = Color(0xFFE6E6E6);

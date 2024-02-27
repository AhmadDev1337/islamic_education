// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import '../../Speaking/speak_home.dart';

class Card1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return TeacherSpeakHome();
              },
            ),
          );
        },
        child: Flexible(
          child: Container(
            width: 130,
            height: 60,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  offset: Offset(4.0, 4.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0,
                  color: Colors.grey.shade500,
                ),
                BoxShadow(
                  offset: Offset(-4.0, -4.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0,
                  color: Colors.white,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.asset(
                    "assets/images/Speaking Icon.png",
                    height: 150.0,
                    width: 150.0,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Speaking",
                  style: TextStyle(
                    color: Color(0xFF0D0D0D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "Practice",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF404040),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:islamic_education/home/student/piechart/config/size.dart';

import 'card1.dart';
import 'card2.dart';
import 'card3.dart';
import 'card4.dart';

class CardWidget extends StatefulWidget {
  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    double fontSize(double size) {
      return size * width / 414;
    }

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: width / 20),
          alignment: Alignment.centerLeft,
          child: Text(
            "Explore Courses",
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize(20)),
          ),
        ),
        SizedBox(height: 10),
        Flexible(
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            children: [
              AnimationLimiter(
                child: AnimationConfiguration.synchronized(
                  duration: const Duration(milliseconds: 400),
                  child: SlideAnimation(
                    curve: Curves.decelerate,
                    child: FadeInAnimation(
                      child: Card1(),
                    ),
                  ),
                ),
              ),
              AnimationLimiter(
                child: AnimationConfiguration.synchronized(
                  duration: const Duration(milliseconds: 400),
                  child: SlideAnimation(
                    curve: Curves.decelerate,
                    child: FadeInAnimation(
                      child: Card2(),
                    ),
                  ),
                ),
              ),
              AnimationLimiter(
                child: AnimationConfiguration.synchronized(
                  duration: const Duration(milliseconds: 400),
                  child: SlideAnimation(
                    curve: Curves.decelerate,
                    child: FadeInAnimation(
                      child: Card3(),
                    ),
                  ),
                ),
              ),
              AnimationLimiter(
                child: AnimationConfiguration.synchronized(
                  duration: const Duration(milliseconds: 400),
                  child: SlideAnimation(
                    curve: Curves.decelerate,
                    child: FadeInAnimation(
                      child: Card4(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

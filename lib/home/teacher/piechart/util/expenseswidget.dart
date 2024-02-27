// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:islamic_education/home/student/piechart/util/piechart.dart';

import '../config/colors.dart';
import '../config/size.dart';
import '../config/strings.dart';

class ExpensesWidget extends StatefulWidget {
  @override
  _ExpensesWidgetState createState() => _ExpensesWidgetState();
}

class _ExpensesWidgetState extends State<ExpensesWidget> {
  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    double fontSize(double size) {
      return size * width / 414;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: height / 14,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: width / 20),
                child: AnimationLimiter(
                  child: AnimationConfiguration.synchronized(
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      curve: Curves.decelerate,
                      child: FadeInAnimation(
                        child: Text(
                          "Skill Statistics",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize(20)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Center(
                  child: AnimationLimiter(
                    child: AnimationConfiguration.synchronized(
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                        curve: Curves.decelerate,
                        child: FadeInAnimation(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: category.map((data) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      width: 10,
                                      height: 5,
                                      decoration: BoxDecoration(
                                          color: AppColors.pieColors[
                                              category.indexOf(data)],
                                          shape: BoxShape.circle),
                                    ),
                                    Text(
                                      data['name'],
                                      style: TextStyle(
                                        fontSize: fontSize(13),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: AnimationLimiter(
                    child: AnimationConfiguration.synchronized(
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                        curve: Curves.decelerate,
                        child: FadeInAnimation(
                          child: PieChart(),
                        ),
                      ),
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

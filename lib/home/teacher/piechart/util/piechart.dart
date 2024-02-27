// ignore_for_file: avoid_function_literals_in_foreach_calls, sort_child_properties_last, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings, unnecessary_string_escapes

import 'package:flutter/material.dart';

import '../config/colors.dart';
import '../config/size.dart';
import '../config/strings.dart';
import 'piechartcustompainter.dart';

class PieChart extends StatefulWidget {
  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart>
    with SingleTickerProviderStateMixin {
  double total = 0;
  @override
  void initState() {
    super.initState();
    category.forEach((e) => total += e['amount']);
  }

  @override
  Widget build(BuildContext context) {
    var width = SizeConfig.getWidth(context);
    double fontSize(double size) {
      return size * width / 414;
    }

    return LayoutBuilder(
      builder: (context, constraint) {
        return Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(44, 164, 167, 189),
              shape: BoxShape.circle,
              boxShadow: AppColors.neumorpShadow),
          child: Stack(
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: constraint.maxWidth * 0.5,
                  child: CustomPaint(
                    child: Container(),
                    foregroundPainter: PieChartCustomPainter(
                      width: constraint.maxWidth * 0.3,
                      categories: category,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: constraint.maxWidth * .5,
                  decoration: BoxDecoration(
                      color: AppColors.primaryWhite,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(3, 3),
                            color: Colors.black38)
                      ]),
                  child: Center(
                    child: Text(
                      total.toString() + "\%",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: fontSize(22)),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

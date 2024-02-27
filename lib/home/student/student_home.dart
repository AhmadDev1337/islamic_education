// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:islamic_education/home/student/piechart/util/cardwidget.dart';
import 'package:islamic_education/home/student/piechart/util/expenseswidget.dart';

import 'Score/student_score.dart';
import 'piechart/config/colors.dart';

class StudentHomePage extends StatefulWidget {
  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _StudentHomePageState extends State<StudentHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimationLimiter(
        child: AnimationConfiguration.synchronized(
          duration: const Duration(milliseconds: 400),
          child: SlideAnimation(
            curve: Curves.decelerate,
            child: FadeInAnimation(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  // welcome
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Hi, Student',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await _auth.signOut();
                                  print("Student logged out");
                                },
                                child: Icon(
                                  Icons.exit_to_app,
                                  size: 25,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Let's start learning_^",
                            style:
                                TextStyle(fontSize: 15, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //chart
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(4.0, 4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0,
                              color: Colors.grey.shade500,
                            ),
                            const BoxShadow(
                              offset: Offset(-4.0, -4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        child: BlurryContainer(
                            blur: 2,
                            color: Colors.white,
                            child: ExpensesWidget()),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Divider(
                      thickness: 1,
                      color: Color.fromARGB(255, 204, 204, 204),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // grid
                  Flexible(
                    child: CardWidget(),
                  ),
                  const SizedBox(height: 15),

                  AnimationLimiter(
                    child: AnimationConfiguration.synchronized(
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                        curve: Curves.decelerate,
                        child: FadeInAnimation(
                          child: LayoutBuilder(builder: (context, constraint) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return RaportSiswaStudent();
                                      },
                                    ),
                                  );
                                },
                                child: Flexible(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(13),
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(0, 17),
                                          blurRadius: 23,
                                          spreadRadius: -13,
                                          color: kShadowColor,
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Center(
                                        child: Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              children: <Widget>[
                                                Image.asset(
                                                  "assets/images/teacher.png",
                                                  width: 50,
                                                  height: 50,
                                                ),
                                                const SizedBox(width: 5),
                                                const Text(
                                                  "Study Score",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: kBackgroundColor,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // welcome
          ),
        ),
      ),
    );
  }
}

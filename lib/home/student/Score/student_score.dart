// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class RaportSiswaStudent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Student Score",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D0D0D),
          title: Center(
            child: Text(
              'Student Score',
              style: GoogleFonts.acme(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
        backgroundColor: const Color(0xFFF2F2F2),
        body: Padding(
          padding: const EdgeInsets.all(7.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('raportSiswa')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Container(
                    child: Center(
                      child: SpinKitWave(
                        color: Colors.cyan,
                        size: 25,
                      ),
                    ),
                  ),
                );
              }
              final documents = snapshot.data!.docs;
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final name = documents[index]['name'];
                  final score1 = documents[index]['score1'];
                  final score2 = documents[index]['score2'];
                  final score3 = documents[index]['score3'];
                  final score4 = documents[index]['score4'];

                  return Container(
                    padding: EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      title: Text(
                        'Name: $name',
                        style: GoogleFonts.roboto(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Column(
                        children: [
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Speaking Score : $score1',
                                style: GoogleFonts.nunito(color: Colors.red),
                              ),
                              Text(
                                'Writing Score  : $score2',
                                style: GoogleFonts.nunito(color: Colors.red),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Reading Score   : $score3',
                                style: GoogleFonts.nunito(color: Colors.red),
                              ),
                              Text(
                                'Listening Score : $score4',
                                style: GoogleFonts.nunito(color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

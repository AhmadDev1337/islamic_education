// ignore_for_file: unused_field, prefer_const_constructors, prefer_final_fields, library_private_types_in_public_api, use_key_in_widget_constructors, avoid_unnecessary_containers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class RaportSiswaTeacher extends StatefulWidget {
  @override
  _RaportSiswaTeacherState createState() => _RaportSiswaTeacherState();
}

class _RaportSiswaTeacherState extends State<RaportSiswaTeacher> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _score1Controller = TextEditingController();
  TextEditingController _score2Controller = TextEditingController();
  TextEditingController _score3Controller = TextEditingController();
  TextEditingController _score4Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Student Score",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0D0D0D),
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
        backgroundColor: Color(0xFFF2F2F2),
        body: Padding(
          padding: EdgeInsets.all(7.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('raportSiswa').snapshots(),
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
                        final document = documents[index];
                        final name = document['name'];
                        final score1 = document['score1'];
                        final score2 = document['score2'];
                        final score3 = document['score3'];
                        final score4 = document['score4'];
                        final docId = document.id;

                        return Container(
                          padding: EdgeInsets.only(bottom: 15),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Name : $name'),
                                PopupMenuButton<void>(
                                  itemBuilder: (BuildContext context) {
                                    return <PopupMenuEntry<void>>[
                                      PopupMenuItem<void>(
                                        child: ListTile(
                                          leading: Icon(Icons.edit),
                                          title: Text('Input'),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                String editedName = name;
                                                int editedScore1 = score1;
                                                int editedScore2 = score2;
                                                int editedScore3 = score3;
                                                int editedScore4 = score4;

                                                return AlertDialog(
                                                  title: Text(
                                                      'Input Name and Score'),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TextField(
                                                        onChanged: (value) {
                                                          editedName = value;
                                                        },
                                                        controller:
                                                            TextEditingController(
                                                                text: name),
                                                        decoration:
                                                            InputDecoration(
                                                                labelText:
                                                                    'Name'),
                                                      ),
                                                      TextField(
                                                        onChanged: (value) {
                                                          editedScore1 =
                                                              int.tryParse(
                                                                      value) ??
                                                                  0;
                                                        },
                                                        controller:
                                                            TextEditingController(
                                                                text: score1
                                                                    .toString()),
                                                        decoration: InputDecoration(
                                                            labelText:
                                                                'Speaking Score'),
                                                      ),
                                                      TextField(
                                                        onChanged: (value) {
                                                          editedScore2 =
                                                              int.tryParse(
                                                                      value) ??
                                                                  0;
                                                        },
                                                        controller:
                                                            TextEditingController(
                                                                text: score2
                                                                    .toString()),
                                                        decoration: InputDecoration(
                                                            labelText:
                                                                'Writing Score'),
                                                      ),
                                                      TextField(
                                                        onChanged: (value) {
                                                          editedScore3 =
                                                              int.tryParse(
                                                                      value) ??
                                                                  0;
                                                        },
                                                        controller:
                                                            TextEditingController(
                                                                text: score3
                                                                    .toString()),
                                                        decoration: InputDecoration(
                                                            labelText:
                                                                'Reading Score'),
                                                      ),
                                                      TextField(
                                                        onChanged: (value) {
                                                          editedScore4 =
                                                              int.tryParse(
                                                                      value) ??
                                                                  0;
                                                        },
                                                        controller:
                                                            TextEditingController(
                                                                text: score4
                                                                    .toString()),
                                                        decoration: InputDecoration(
                                                            labelText:
                                                                'Listening Score'),
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'raportSiswa')
                                                            .doc(docId)
                                                            .update({
                                                          'name': editedName,
                                                          'score1':
                                                              editedScore1,
                                                          'score2':
                                                              editedScore2,
                                                          'score3':
                                                              editedScore3,
                                                          'score4':
                                                              editedScore4,
                                                        });

                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Save'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      PopupMenuItem<void>(
                                        child: ListTile(
                                          leading: Icon(Icons.delete),
                                          title: Text('Delete'),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Delete Name and Score'),
                                                  content: Text(
                                                      'Are you sure you want to delete this entry?'),
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        // Hapus data dari Firestore
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'raportSiswa')
                                                            .doc(docId)
                                                            .delete();

                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Delete'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ];
                                  },
                                ),
                              ],
                            ),
                            subtitle: Column(
                              children: [
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Speaking Score : $score1'),
                                    Text('Writing Score  : $score2'),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Reading Score   : $score3'),
                                    Text('Listening Score : $score4'),
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
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                String newName = '';
                int newScore1 = 0;
                int newScore2 = 0;
                int newScore3 = 0;
                int newScore4 = 0;

                return AlertDialog(
                  title: Text('Add New Name and Score'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onChanged: (value) {
                          newName = value;
                        },
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      TextField(
                        onChanged: (value) {
                          newScore1 = int.tryParse(value) ?? 0;
                        },
                        decoration:
                            InputDecoration(labelText: 'Speaking Score'),
                      ),
                      TextField(
                        onChanged: (value) {
                          newScore2 = int.tryParse(value) ?? 0;
                        },
                        decoration: InputDecoration(labelText: 'Writing Score'),
                      ),
                      TextField(
                        onChanged: (value) {
                          newScore3 = int.tryParse(value) ?? 0;
                        },
                        decoration: InputDecoration(labelText: 'Reading Score'),
                      ),
                      TextField(
                        onChanged: (value) {
                          newScore4 = int.tryParse(value) ?? 0;
                        },
                        decoration:
                            InputDecoration(labelText: 'Listening Score'),
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () async {
                        if (newName.isNotEmpty && newScore1 > 0) {
                          await _firestore.collection('raportSiswa').add({
                            'name': newName,
                            'score1': newScore1,
                            'score2': newScore2,
                            'score3': newScore3,
                            'score4': newScore4,
                          });
                          Navigator.of(context).pop();
                        } else {}
                      },
                      child: Text('Add'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                );
              },
            );
          },
          elevation: 10,
          backgroundColor: Colors.grey.shade800,
          child: Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}

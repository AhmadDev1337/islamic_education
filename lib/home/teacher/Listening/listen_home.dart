// ignore_for_file: avoid_print, library_private_types_in_public_api, avoid_unnecessary_containers, depend_on_referenced_packages, unused_element, unused_local_variable, prefer_final_fields, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';

class KeyAnswer {
  final int index;
  final String answer;

  KeyAnswer({required this.index, required this.answer});
}

class TeacherListenPage extends StatefulWidget {
  const TeacherListenPage({Key? key}) : super(key: key);

  @override
  _TeacherListenPageState createState() => _TeacherListenPageState();
}

class _TeacherListenPageState extends State<TeacherListenPage> {
  List<Map<String, dynamic>> songsData = [];

  List<Map<String, dynamic>> filteredSongs = [];

  @override
  void initState() {
    super.initState();
    fetchSongsData();
  }

  Future<void> fetchSongsData() async {
    final response =
        await http.get(Uri.parse('https://pastebin.com/raw/vHBhRZL3'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        songsData = List<Map<String, dynamic>>.from(data);
        filteredSongs = List.from(songsData);
      });
    } else {
      Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: const Center(
            child: SpinKitWave(
              color: Colors.cyan,
              size: 25,
            ),
          ),
        ),
      );
    }
  }

  void _filterSongs(String searchText) {
    setState(() {
      filteredSongs = songsData
          .where((song) =>
              song['name']
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              song['country']
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Listening Class",
      home: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Listening Class",
                  style: GoogleFonts.acme(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    wordSpacing: 2,
                  ),
                ),
                const SizedBox(width: 75),
                Flexible(
                  child: SizedBox(
                    height: 30,
                    child: TextField(
                      onChanged: _filterSongs,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Search Song...",
                        hintStyle: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: ListView.builder(
          itemCount: filteredSongs.length,
          itemBuilder: (context, index) {
            final song = filteredSongs[index];

            Color levelColor;
            IconData levelIcon;

            // Set color and icon based on level
            switch (song['level']) {
              case 'Easy level':
                levelColor = Colors.green;
                levelIcon = Icons.music_note_outlined;
                break;
              case 'Medium level':
                levelColor = Colors.purple;
                levelIcon = Icons.music_note_outlined;
                break;
              case 'Hard level':
                levelColor = Colors.red;
                levelIcon = Icons.music_note_outlined;
                break;
              default:
                levelColor = Colors.grey;
                levelIcon = Icons.music_note_outlined;
            }

            return InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SongTest(
                    audioUrl: song['audioUrl'],
                    imageUrl: song['imageUrl'],
                    conclusion: song['conclusion'],
                    firestore: FirebaseFirestore.instance,
                    initialMessage: "Hello, this is my initial message.",
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(song['imageUrl']),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        song['name'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        song['country'],
                                        style:
                                            TextStyle(color: Colors.grey[500]),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          AnimatedContainer(
                            height: 35,
                            padding: const EdgeInsets.all(5),
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: levelColor,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                levelIcon,
                                color: levelColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: Text(
                                    song['genre'],
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: levelColor.withAlpha(30),
                                  ),
                                  child: Text(
                                    song['level'],
                                    style: TextStyle(
                                      color: levelColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              song['time'],
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SongTest extends StatefulWidget {
  final FirebaseFirestore firestore;
  final String audioUrl;
  final String imageUrl;
  final String conclusion;
  final String initialMessage;

  const SongTest({
    Key? key,
    required this.audioUrl,
    required this.imageUrl,
    required this.conclusion,
    required this.firestore,
    required this.initialMessage,
  }) : super(key: key);

  @override
  State<SongTest> createState() => _SongTestState();
}

class _SongTestState extends State<SongTest> {
  bool isPlaying = false;

  final AudioPlayer player = AudioPlayer();
  double playerPosition = 0.0;
  double playerDuration = 1.0;

  Future<void> toggleAudio(String url) async {
    if (isPlaying) {
      await player.pause();
    } else {
      await player.play(UrlSource(url));
      Duration? duration = await player.getDuration();
      setState(() {
        playerDuration = duration!.inMilliseconds.toDouble();
      });

      Timer.periodic(Duration(milliseconds: 500), (timer) async {
        if (isPlaying) {
          Duration? position = await player.getCurrentPosition();
          setState(() {
            playerPosition = position!.inMilliseconds.toDouble();
          });
        }
      });
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  Future<void> seekToSecond(double seconds) async {
    if (isPlaying) {
      // Hentikan pemutaran jika sedang diputar
      await player.pause();
    }

    try {
      Duration newDuration = Duration(seconds: seconds.toInt());
      await player.seek(newDuration);
    } catch (e) {
      // Tangani kesalahan seek audio
      print('Error seeking audio: $e');
    }

    await Future.delayed(Duration(milliseconds: 100));

    setState(() {
      playerPosition = seconds;
    });

    if (isPlaying) {
      await player.resume();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40, bottom: 15),
              child: Text(
                "Listening Course",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
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
                  child: Column(
                    children: [
                      Slider(
                        value: playerPosition,
                        min: 0,
                        max: playerDuration,
                        onChanged: (value) {},
                        onChangeEnd: (value) {
                          seekToSecond(value);
                        },
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          toggleAudio(widget.audioUrl);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13, right: 13, top: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "INSTRUCTION",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      wordSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Your task is to listen to the song above and write down a conclusion about the song for your teacher to review",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      wordSpacing: 1,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    "This is the conclusion :",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            AnimationLimiter(
              child: AnimationConfiguration.synchronized(
                child: SlideAnimation(
                  curve: Curves.decelerate,
                  child: FadeInAnimation(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 60),
                    child: Expanded(
                      child: Container(
                        height: 450,
                        decoration: BoxDecoration(
                          color: Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Text(widget.conclusion),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

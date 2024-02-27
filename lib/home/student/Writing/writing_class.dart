// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors_in_immutables, prefer_const_constructors, unnecessary_this, use_build_context_synchronously, unused_field, unused_local_variable, prefer_final_fields, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, no_logic_in_create_state, unnecessary_import, depend_on_referenced_packages, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String sender;
  final String content;
  final String originalContent;
  final String score;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.content,
    required this.originalContent,
    required this.score,
    required this.timestamp,
  });
}

class CardData {
  final int id;
  final String title;
  final String image;
  final String author;
  final String score;
  final String review;
  final String view;
  final String desc;

  CardData({
    required this.id,
    required this.title,
    required this.image,
    required this.author,
    required this.score,
    required this.review,
    required this.view,
    required this.desc,
  });

  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      author: json['author'],
      score: json['score'],
      review: json['review'],
      view: json['view'],
      desc: json['desc'],
    );
  }
}

class WritingPage extends StatefulWidget {
  @override
  _WritingPageState createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  late Future<List<CardData>> cardDataList;

  @override
  void initState() {
    super.initState();
    cardDataList = fetchCardData();
  }

  Future<List<CardData>> fetchCardData() async {
    final response = await http.get(
      Uri.parse('https://pastebin.com/raw/ZxwQ6CjM'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<CardData> cardDataList =
          jsonData.map((data) => CardData.fromJson(data)).toList();
      return cardDataList;
    } else {
      throw Scaffold(
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Writing Class",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D0D0D),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Writing Class', style: GoogleFonts.acme()),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ForumChatPage(
                              firestore: FirebaseFirestore.instance,
                              initialMessage: "",
                            )));
                  },
                  child: Icon(Icons.more_vert_rounded)),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFF2F2F2),
        body: FutureBuilder<List<CardData>>(
          future: cardDataList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
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
            } else if (snapshot.hasError) {
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
            } else {
              final cardDataList = snapshot.data!;

              return Container(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Instruction",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10),
                      child: Text(
                        "Choose your favorite story, read slowly and create your own story",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Flexible(
                      child: Swiper(
                        layout: SwiperLayout.CUSTOM,
                        customLayoutOption: CustomLayoutOption(
                          startIndex: -1,
                          stateCount: 3,
                        )
                          ..addRotate([
                            -45.0 / 180,
                            0.0,
                            45.0 / 180,
                          ])
                          ..addTranslate([
                            Offset(-370.0, -40.0),
                            Offset(0.0, 0.0),
                            Offset(370.0, -40.0),
                          ]),
                        itemWidth: 300.0,
                        itemHeight: 600.0,
                        itemBuilder: (context, index) {
                          final cardData = cardDataList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CardDetailPage(
                                  cardData: cardData,
                                  firestore: FirebaseFirestore.instance,
                                  initialMessage: "",
                                ),
                              ));
                            },
                            child: Flexible(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF0D0D0D).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      cardData.image,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                          child: Text(
                                            cardData.title,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.acme(
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: cardDataList.length,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class CardDetailPage extends StatefulWidget {
  final CardData cardData;
  final String initialMessage;
  final FirebaseFirestore firestore;

  const CardDetailPage({
    Key? key,
    required this.cardData,
    required this.firestore,
    required this.initialMessage,
  }) : super(key: key);

  @override
  State<CardDetailPage> createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> {
  final TextEditingController _messageController = TextEditingController();

  final List<TextEditingController> _textEditingControllers = [];

  void sendMessageToFirestore(String messageContent) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String senderName = await fetchSenderName(user.uid);
      ChatMessage message = ChatMessage(
        sender: senderName,
        content: "",
        originalContent: messageContent,
        score: "",
        timestamp: DateTime.now(),
      );
      await widget.firestore.collection('messages').add({
        'sender': message.sender,
        'content': message.content,
        'originalContent': message.originalContent,
        'score': message.score,
        'timestamp': message.timestamp,
      });
    }
  }

  Future<String> fetchSenderName(String uid) async {
    DocumentSnapshot userSnapshot =
        await widget.firestore.collection('User').doc(uid).get();

    if (userSnapshot.exists) {
      return userSnapshot['name'] as String;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.cardData.image;
    final title = widget.cardData.title;
    final author = widget.cardData.author;
    final score = widget.cardData.score;
    final review = widget.cardData.review;
    final view = widget.cardData.view;
    final desc = widget.cardData.desc;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(
            height: 550,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromARGB(255, 131, 129, 129),
                        Color.fromARGB(255, 206, 199, 199),
                      ],
                      stops: [0.0, 0.4],
                    ).createShader(bounds),
                    child: Image.network(
                      image,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Positioned(
                  top: 56,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF0D0D0D),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 250),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    height: 1.2,
                    color: Color(0xFF0D0D0D),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                author,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIconText(
                    Icons.star,
                    Colors.orange[300]!,
                    '$score($review)',
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  _buildIconText(
                    Icons.visibility,
                    Colors.orange[300]!,
                    '$view Read',
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  desc,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(color: Color(0xFF0D0D0D)),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Write Your Story Here:",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              AnimationLimiter(
                child: AnimationConfiguration.synchronized(
                  child: SlideAnimation(
                    curve: Curves.decelerate,
                    child: FadeInAnimation(
                      duration: const Duration(milliseconds: 500),
                      delay: const Duration(milliseconds: 60),
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        padding: EdgeInsets.all(20),
                        child: TextField(
                          controller: _messageController,
                          style: TextStyle(
                            color: kDefaultIconDarkColor,
                          ),
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type something here',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String messageContent = _messageController.text;
          sendMessageToFirestore(messageContent);
          _messageController.clear();
        },
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        child: const Icon(
          Icons.send,
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 14,
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class ForumChatPage extends StatefulWidget {
  final FirebaseFirestore firestore;
  final String initialMessage;

  ForumChatPage({required this.firestore, required this.initialMessage});

  @override
  _ForumChatPageState createState() => _ForumChatPageState(
        initialMessage: "",
      );
}

class _ForumChatPageState extends State<ForumChatPage> {
  _ForumChatPageState({required this.initialMessage});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();
  late final String initialMessage;
  List<ChatMessage> messages = [];
  String userRole = '';
  User? user;

  @override
  void initState() {
    super.initState();
    fetchUserRole();
    _messageController.text = initialMessage;
  }

  Future<void> fetchUserRole() async {
    final user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot =
          await widget.firestore.collection('User').doc(user.uid).get();

      if (userSnapshot.exists) {
        setState(() {
          userRole = userSnapshot['role'] as String;
        });
      }
    }
  }

  void sendMessage() async {
    final user = _auth.currentUser;
    if (user != null) {
      String content = _messageController.text.trim();
      if (content.isNotEmpty) {
        String senderName = await fetchSenderName(user.uid);
        ChatMessage message = ChatMessage(
          sender: senderName,
          content: "",
          originalContent: content,
          score: "",
          timestamp: DateTime.now(),
        );
        await widget.firestore.collection('messages').add({
          'sender': message.sender,
          'content': message.content,
          'originalContent': message.originalContent,
          'score': message.score,
          'timestamp': message.timestamp,
        });
        _messageController.clear();
      }
    }
  }

  Future<String> fetchSenderName(String uid) async {
    DocumentSnapshot userSnapshot =
        await widget.firestore.collection('User').doc(uid).get();

    if (userSnapshot.exists) {
      return userSnapshot['name'] as String;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Writing Class",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0D0D0D),
          title: Text('Writing Class', style: GoogleFonts.acme()),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: widget.firestore
                    .collection('messages')
                    .orderBy('timestamp')
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

                  List<Widget> messageWidgets = snapshot.data!.docs.map((doc) {
                    String score = doc['score'] as String;
                    Timestamp timestamp = doc['timestamp'] as Timestamp;
                    String originalContent = doc['originalContent'] as String;
                    String content = doc['content'] as String;

                    Color textColor =
                        userRole == 'teacher' ? Colors.red : Colors.black;

                    // Generate colored text spans
                    List<TextSpan> textSpans = generateColoredText(
                        content, originalContent, textColor);

                    return Container(
                      padding: EdgeInsets.all(15),
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[300],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.account_circle,
                                        size: 30, color: Colors.grey),
                                    SizedBox(width: 10),
                                    Text(
                                      doc['sender'] as String,
                                      style: GoogleFonts.nunito(
                                          color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  doc['originalContent'] as String,
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.nunito(
                                    fontSize: 13,
                                    color: textColor,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  doc['content'] as String,
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.nunito(
                                    fontSize: 13,
                                    color: textColor,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(0xFFF2F2F2),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Score : ",
                                            style: GoogleFonts.nunito(
                                              fontSize: 11,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            doc['score'] as String,
                                            style: GoogleFonts.nunito(
                                              fontSize: 11,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      timestamp.toDate().toString(),
                                      style: TextStyle(
                                        fontSize: 8,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList();

                  return ListView(
                    children: messageWidgets,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> generateColoredText(
      String content, String originalContent, Color textColor) {
    List<TextSpan> textSpans = [];

    List<String> contentWords = content.split(' ');
    List<String> originalWords = originalContent.split(' ');

    for (int i = 0; i < contentWords.length; i++) {
      String contentWord = contentWords[i];
      String originalWord = i < originalWords.length ? originalWords[i] : '';

      if (contentWord == originalWord) {
        textSpans.add(TextSpan(text: contentWord + ' '));
      } else {
        textSpans.add(TextSpan(
          text: contentWord + ' ',
          style: TextStyle(color: textColor),
        ));
      }
    }

    return textSpans;
  }
}

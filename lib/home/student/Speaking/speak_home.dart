// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables, unnecessary_string_interpolations, avoid_print, depend_on_referenced_packages, prefer_final_fields, avoid_unnecessary_containers

// ignore_for_file:
import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeakHome extends StatefulWidget {
  @override
  _SpeakHomeState createState() => _SpeakHomeState();
}

class _SpeakHomeState extends State<SpeakHome> {
  List<ContactItem> contacts = [];

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    final response =
        await http.get(Uri.parse('https://pastebin.com/raw/VAttZdvd'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final contactsJson = jsonData['contacts'] as List<dynamic>;

      setState(() {
        contacts = contactsJson
            .map((contactJson) => ContactItem.fromJson(contactJson))
            .toList();
      });
    } else {
      Scaffold(
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
      home: Scaffold(
        backgroundColor: Color(0xFFF2F2F2),
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Speaking Class",
                  style: GoogleFonts.acme(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    wordSpacing: 2,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "Contact",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(contact.image),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: TextStyle(
                          color: Color(0xFF0D0D0D),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        contact.lastChat,
                        style: TextStyle(
                          color: Color(0xFF0D0D0D),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    contact.onlineStatus,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(contact: contact),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final ContactItem contact;

  ChatPage({required this.contact});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool isPlaying = false;
  bool isListening = false;
  List<Message> chatMessages = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

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

  Future<void> fetchMessages() async {
    final messages = widget.contact.detailPage.messages;

    setState(() {
      chatMessages = messages;
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
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back),
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.contact.image),
                      maxRadius: 19,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contact.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.contact.onlineStatus,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: Colors.grey.shade900,
        ),
        body: Container(
          constraints: const BoxConstraints.expand(
            height: double.infinity,
            width: double.infinity,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFF2F2F2),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: chatMessages.length,
                  itemBuilder: (context, index) {
                    final message = chatMessages[index];

                    if (message.sender.startsWith('receiver')) {
                      return getReceiverView(message.sender, message.text);
                    } else {
                      return getSenderView(message.sender, message.text);
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
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
                  toggleAudio(widget.contact.audioUrl);
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget getReceiverView(String sender, String text) => ChatBubble(
        clipper: ChatBubbleClipper9(type: BubbleType.receiverBubble),
        backGroundColor: Color(0xffE7E7ED),
        margin: EdgeInsets.only(top: 20),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: GestureDetector(
            onTap: () => listen(sender),
            child: Text(
              text,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      );

  Widget getSenderView(String sender, String text) => ChatBubble(
        clipper: ChatBubbleClipper9(type: BubbleType.sendBubble),
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 20),
        backGroundColor: Color(0xFFCCE5FF),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: GestureDetector(
            onTap: () => listen(sender),
            child: Text(
              text,
              style: TextStyle(color: Color(0xFF404040)),
            ),
          ),
        ),
      );

  void listen(String sender) async {
    bool available = await _speechToText.initialize(
      onStatus: (status) => print("$status"),
      onError: (errorNotification) => print("$errorNotification"),
    );

    if (available) {
      setState(() {
        isListening = true;
      });

      _speechToText.listen(
        onResult: (result) {
          setState(() {
            // Find the index of the last message with the same sender
            int lastIndex = chatMessages
                .lastIndexWhere((message) => message.sender == sender);

            // Update the recognized text for the last message with the same sender
            if (lastIndex != -1) {
              chatMessages[lastIndex] =
                  Message(sender: sender, text: result.recognizedWords);
            }
          });
        },
      );
    }
  }
}

class ContactItem {
  final String image;
  final String name;
  final String onlineStatus;
  final String lastChat;
  final String audioUrl;
  final DetailPage detailPage;

  ContactItem({
    required this.image,
    required this.name,
    required this.onlineStatus,
    required this.lastChat,
    required this.audioUrl,
    required this.detailPage,
  });

  factory ContactItem.fromJson(Map<String, dynamic> json) {
    return ContactItem(
      image: json['image'],
      name: json['name'],
      onlineStatus: json['onlineStatus'],
      lastChat: json['lastChat'],
      audioUrl: json['detailPage']['audioUrl'],
      detailPage: DetailPage.fromJson(json['detailPage']),
    );
  }
}

class DetailPage {
  final String pageTitle;
  final List<Message> messages;

  DetailPage({required this.pageTitle, required this.messages});

  factory DetailPage.fromJson(Map<String, dynamic> json) {
    final messagesJson = json['messages'] as List<dynamic>;
    final messages = messagesJson
        .map((messageJson) => Message.fromJson(messageJson))
        .toList();

    return DetailPage(
      pageTitle: json['pageTitle'],
      messages: messages,
    );
  }
}

class Message {
  final String sender;
  final String text;

  Message({required this.sender, required this.text});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      text: json['text'],
    );
  }
}

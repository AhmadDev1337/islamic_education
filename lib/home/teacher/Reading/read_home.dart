// ignore_for_file: unused_field, unnecessary_null_comparison, avoid_print, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, depend_on_referenced_packages

import 'dart:convert';
import 'dart:ui';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class JsonData {
  final String imgUrl;
  final String name;
  final String author;
  final String score;
  final String review;
  final String view;
  final String desc;

  JsonData({
    required this.imgUrl,
    required this.name,
    required this.author,
    required this.score,
    required this.review,
    required this.view,
    required this.desc,
  });
}

class TeacherReadingPage extends StatefulWidget {
  const TeacherReadingPage({Key? key}) : super(key: key);

  @override
  State<TeacherReadingPage> createState() => _TeacherReadingPageState();
}

class _TeacherReadingPageState extends State<TeacherReadingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<JsonData> jsonDataList = [];

  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<JsonData> filteredJsonDataList = [];

  void _startSearch() {
    setState(() {
      isSearching = true;
      _searchController.text = '';
    });
  }

  void _stopSearch() {
    setState(() {
      isSearching = false;
      _searchController.clear();
      filteredJsonDataList.clear();
    });
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredJsonDataList = jsonDataList
            .where((jsonData) =>
                jsonData.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        filteredJsonDataList = List.from(jsonDataList);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    const singleJsonUrl = 'https://pastebin.com/raw/bSaH9eMe';

    try {
      final response = await http.get(Uri.parse(singleJsonUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        jsonDataList = jsonData.map<JsonData>((data) {
          return JsonData(
            imgUrl: data['imgUrl'],
            name: data['name'],
            author: data['author'],
            score: data['score'],
            review: data['review'],
            view: data['view'],
            desc: data['desc'],
          );
        }).toList();

        filteredJsonDataList = List.from(jsonDataList);

        setState(() {});
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
    } catch (e) {
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

  int calculatePageCount() {
    return (filteredJsonDataList.length / (itemsPerPage * storiesPerRow))
        .ceil();
  }

  List<List<JsonData>> chunkStories() {
    final List<List<JsonData>> chunkedStories = [];
    for (int i = 0; i < filteredJsonDataList.length; i += itemsPerPage) {
      final List<JsonData> chunk = filteredJsonDataList.sublist(
        i,
        i + itemsPerPage,
      );
      chunkedStories.add(chunk);
    }
    return chunkedStories;
  }

  List<JsonData> getStoriesForCurrentPage() {
    final int startIndex = currentPage * itemsPerPage * storiesPerRow;
    final int endIndex = (currentPage + 1) * itemsPerPage * storiesPerRow;
    return filteredJsonDataList.sublist(
        startIndex, endIndex.clamp(0, filteredJsonDataList.length));
  }

  int currentPage = 0;
  final int itemsPerPage = 2;
  final int storiesPerRow = 2;

  void goToNextPage() {
    final int lastPage = calculatePageCount() - 1;
    if (currentPage < lastPage) {
      setState(() {
        currentPage++;
      });
    }
  }

  void goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Reading Class",
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Reading Class",
                style: GoogleFonts.acme(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSearching ? _stopSearch() : _startSearch();
                    });
                  },
                  child: AnimSearchBar(
                    width: 200,
                    rtl: true,
                    textController: _searchController,
                    onSuffixTap: () {
                      _stopSearch();
                    },
                    onSubmitted: _performSearch,
                    helpText: "Search...",
                    animationDurationInMilli: 735,
                    color: Color(0xFF0D0D0D),
                    searchIconColor: Color(0xFFF2F2F2),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFF0D0D0D),
        ),
        backgroundColor: Color(0xFFF2F2F2),
        body: AnimationLimiter(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (int pageIndex = 0;
                    pageIndex < calculatePageCount();
                    pageIndex++)
                  if (pageIndex == currentPage)
                    Column(
                      children: [
                        for (int rowIndex = 0;
                            rowIndex < itemsPerPage;
                            rowIndex++)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (int columnIndex = 0;
                                  columnIndex < storiesPerRow;
                                  columnIndex++)
                                if (rowIndex * storiesPerRow + columnIndex <
                                    getStoriesForCurrentPage().length)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                          jsonData: getStoriesForCurrentPage()[
                                              rowIndex * storiesPerRow +
                                                  columnIndex],
                                        ),
                                      ));
                                    },
                                    child: AnimationLimiter(
                                      child:
                                          AnimationConfiguration.synchronized(
                                        duration:
                                            const Duration(milliseconds: 400),
                                        child: SlideAnimation(
                                          curve: Curves.decelerate,
                                          child: FadeInAnimation(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10, top: 10),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      offset: Offset(4.0, 4.0),
                                                      blurRadius: 15.0,
                                                      spreadRadius: 1.0,
                                                      color:
                                                          Colors.grey.shade500,
                                                    ),
                                                    BoxShadow(
                                                      offset:
                                                          Offset(-4.0, -4.0),
                                                      blurRadius: 15.0,
                                                      spreadRadius: 1.0,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                                width: 150,
                                                child: Center(
                                                  child: buildJsonContainer(
                                                      getStoriesForCurrentPage()[
                                                          rowIndex *
                                                                  storiesPerRow +
                                                              columnIndex]),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        const SizedBox(height: 50),
                      ],
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (calculatePageCount() > 1 && currentPage > 0)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
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
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFF0D0D0D),
                        ),
                        child: GestureDetector(
                          onTap: goToPreviousPage,
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xFFF2F2F2),
                          ),
                        ),
                      ),
                    if (calculatePageCount() > 1 &&
                        currentPage < calculatePageCount() - 1)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
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
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFF0D0D0D),
                        ),
                        child: GestureDetector(
                          onTap: goToNextPage,
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFFF2F2F2),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, Color color, String text) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
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
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D0D0D),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImageWidget(String imgUrl) {
    if (imgUrl != '') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
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
            imgUrl,
            width: 110,
            height: 170,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Container(
        width: 110,
        height: 170,
        color: Colors.grey,
      );
    }
  }

  Widget buildJsonContainer(JsonData jsonData) {
    return Stack(
      children: [
        SizedBox(
          width: 135,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImageWidget(jsonData.imgUrl),
              Container(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: Column(
                  children: [
                    Text(
                      jsonData.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF0D0D0D),
                      ),
                    ),
                    Text(
                      jsonData.author,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 5,
          left: 5,
          child: _buildIconText(
            Icons.star,
            Colors.orange[300]!,
            jsonData.score,
          ),
        ),
      ],
    );
  }
}

class DetailPage extends StatefulWidget {
  final JsonData jsonData;

  const DetailPage({Key? key, required this.jsonData}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final double _confidence = 1.0;
  bool isOpen = false;

  List<Offset> currentOffsets = <Offset>[];
  List<Offset> offsets = <Offset>[];
  List<List<Offset>> allOffsets = [];

  Color selectedColor = Colors.red;
  double strokeWidth = 5;
  List<DrawingPoint> drawingPoints = [];
  List<Offset> currentLine = [];
  bool isBrushActive = false;
  List<List<Offset>> allLines = [];

  Offset? lastPosition;

  void stopPainting() {
    setState(() {
      allOffsets.add(List.from(currentOffsets));
    });
  }

  void clearDrawing() {
    setState(() {
      currentOffsets = [];
      lastPosition = null;
      allLines.clear(); // Clear all drawing lines as well
    });
  }

  @override
  Widget build(BuildContext context) {
    final imgUrl = widget.jsonData.imgUrl;
    final name = widget.jsonData.name;
    final author = widget.jsonData.author;
    final score = widget.jsonData.score;
    final review = widget.jsonData.review;
    final view = widget.jsonData.view;
    final desc = widget.jsonData.desc;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(
            height: 550,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (imgUrl != null)
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
                        imgUrl,
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
                  name,
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
                    Colors.white,
                    '$view Read',
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: GestureDetector(
                  child: GestureDetector(
                    onPanStart: (details) {
                      if (isBrushActive) {
                        // Check if brush is active
                        setState(() {
                          drawingPoints.add(
                            DrawingPoint(
                              details.localPosition,
                              Paint()
                                ..color = selectedColor
                                ..isAntiAlias = true
                                ..strokeWidth = strokeWidth
                                ..strokeCap = StrokeCap.round,
                            ),
                          );
                        });
                      }
                    },
                    onPanUpdate: (details) {
                      if (isBrushActive) {
                        // Check if brush is active
                        setState(() {
                          currentLine.add(details.localPosition);
                        });
                      }
                    },
                    onPanEnd: (details) {
                      if (isBrushActive) {
                        // Check if brush is active
                        setState(() {
                          allLines.add(List.from(currentLine));
                          currentLine.clear();
                        });
                      }
                    },
                    child: CustomPaint(
                      painter: DrawingPainter(
                          lines: allLines,
                          selectedColor: Colors.red,
                          strokeWidth: 3),
                      child: Text(
                        desc,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(color: Color(0xFF0D0D0D)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.center_focus_weak_rounded,
        activeIcon: Icons.close,
        backgroundColor: Colors.grey,
        activeBackgroundColor: Colors.grey,
        spacing: 12.0,
        children: [
          SpeedDialChild(
            child: Icon(Icons.brush_rounded),
            backgroundColor: Colors.grey,
            onTap: () {
              setState(() {
                isBrushActive = !isBrushActive; // Toggle brush state
              });
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.delete_forever_rounded),
            backgroundColor: Colors.grey,
            onTap: () {
              clearDrawing();
            },
          ),
        ],
        onOpen: () {
          setState(() {
            isOpen = true;
          });
        },
        onClose: () {
          setState(() {
            isOpen = false;
          });
        },
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

class DrawingPainter extends CustomPainter {
  final List<List<Offset>> lines;
  final Color selectedColor;
  final double strokeWidth;

  DrawingPainter({
    required this.lines,
    required this.selectedColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = selectedColor
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    for (final line in lines) {
      for (int i = 0; i < line.length - 1; i++) {
        if (line[i] != null && line[i + 1] != null) {
          canvas.drawLine(line[i], line[i + 1], paint);
        } else if (line[i] != null && line[i + 1] == null) {
          canvas.drawPoints(
            PointMode.points,
            [line[i]],
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}

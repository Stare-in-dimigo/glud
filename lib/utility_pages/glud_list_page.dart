import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../glud_pages/content_page.dart';
import '../login_pages/loginpage.dart';
import '../widgets.dart';

int globalIndex = 0;

String convertDateFormat(String originalDate) {
  return originalDate.split(' ')[0];
}

class GludListPage extends StatefulWidget {
  const GludListPage({Key? key}) : super(key: key);

  @override
  _GludListPageState createState() => _GludListPageState();
}

class _GludListPageState extends State<GludListPage> {
  List<Glud> gludList = [];
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await fillwrite();
  }

  Future<void> fillwrite() async {
    final usersRef = _databaseRef.child("users").child(usersUID);
    final snapshot = await usersRef.child("num").get();

    int num = int.parse(snapshot.value.toString());

    var futures = <Future>[];
    for (int i = 1; i <= num; i++) {
      futures.add(loadGludData(i, usersRef));
    }

    await Future.wait(futures);

    setState(() {
      gludList = gludList.reversed.toList();
    });
  }

  Future<void> loadGludData(int index, DatabaseReference usersRef) async {
    var writingRef = usersRef.child("writing").child(index.toString());
    var data = await Future.wait([
      writingRef.child("title").get(),
      writingRef.child("date").get(),
      writingRef.child("content").get(),
      writingRef.child("type").get(),
    ]);

    String title = data[0].value.toString();
    String date = convertDateFormat(data[1].value.toString());
    String content = data[2].value.toString();
    String type = data[3].value.toString();
    String imagePath = getImagePathForType(type);

    Glud glud = Glud(
      date: date,
      imagePath: imagePath,
      type: type,
      content: content,
      completed: true,
      route: const ResultPage(),
      index: index,
    );

    setState(() {
      gludList.add(glud);
    });
  }

  String getImagePathForType(String type) {
    switch (type) {
      case "보도자료":
        return 'assets/images/index/report.png';
      case "반성문":
        return 'assets/images/index/reflection.png';
      case "독서록":
        return 'assets/images/index/booklog.png';
      default:
        return 'assets/images/index/litigation.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body:
          Stack(
            children: [
              buildGludListView(),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 100,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 0.3, 1.0],
                        colors: [
                          Colors.white10,
                          Colors.white70,
                          Colors.white,
                        ],
                      ),
                    ),
                  )),
            ],
          ),
    );
  }

  Widget buildGludListView() {
    return ListView.builder(
      itemCount: gludList.length,
      itemBuilder: (context, index) => buildGludContainer(context, gludList[index]),
      physics: const BouncingScrollPhysics(),
    );
  }

  Widget buildGludContainer(BuildContext context, Glud glud) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: GestureDetector(
        onTap: () {
          if (glud.completed) {
            print(glud.index);
            globalIndex = glud.index;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => glud.route),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('아직 완료되지 않았습니다.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: CustomContainer(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              if (glud.completed)
                Image.asset(glud.imagePath, height: 75)
              else
                const SizedBox(
                  width: 80,
                  height: 80,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: Color(0xFFC0CFDB),
                    ),
                  ),
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '#${glud.index} ${glud.type}',
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          glud.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, color: Color(0xFF5E5E5E)),
                        )
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 5,
                      child: Text(
                        glud.date,
                        style: const TextStyle(
                            fontSize: 15, color: Color(0xFF9D9D9D)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleTap(BuildContext context, Glud glud) {
    if (glud.completed) {
      globalIndex = glud.index;
      Navigator.push(context, MaterialPageRoute(builder: (context) => glud.route));
    } else {
      showIncompleteSnackBar(context);
    }
  }

  void showIncompleteSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('아직 완료되지 않았습니다.'), duration: Duration(seconds: 2)),
    );
  }

  Widget buildGludImage(Glud glud) {
    return glud.completed
        ? Image.asset(glud.imagePath, height: 75)
        : const SizedBox(
      width: 80,
      height: 80,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: CircularProgressIndicator(
          strokeWidth: 5,
          color: Color(0xFFC0CFDB),
        ),
      ),
    );
  }

  Widget buildGludInfo(Glud glud) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '#${glud.index} ${glud.type}',
          maxLines: 1,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          glud.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, color: Color(0xFF5E5E5E)),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            glud.date,
            style: const TextStyle(fontSize: 15, color: Color(0xFF9D9D9D)),
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '내가 작성한 글',
          style: TextStyle(color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      titleSpacing: -10,
      toolbarHeight: 100,
    );
  }
}

class Glud {
  final String date;
  final String imagePath;
  final String type;
  final String content;
  final bool completed;
  final Widget route;
  final int index;

  Glud({
    required this.date,
    required this.imagePath,
    required this.type,
    required this.content,
    required this.completed,
    required this.route,
    required this.index,
  });
}

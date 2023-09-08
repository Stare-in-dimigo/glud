import 'package:flutter/material.dart';

import '../widgets.dart';
import '../glud_pages/content_page.dart';
import 'package:firebase_database/firebase_database.dart';
import '../login_pages/loginpage.dart';

int globalIndex = 0;

String convertDateFormat(String originalDate) {
  // Extract the date part from the original date string
  String formattedDate = originalDate.split(' ')[0];
  return formattedDate;
}

class GludListPage extends StatefulWidget {
  const GludListPage({Key? key}) : super(key: key);

  @override
  _GludListPageState createState() => _GludListPageState();
}

class _GludListPageState extends State<GludListPage> {
  List<Glud> gludList = [];

  Future<void> fillwrite() async {
    final usersRef = FirebaseDatabase.instance.ref();
    final snapshot =
        await usersRef.child("users").child(usersUID).child("num").get();

    int num = int.parse(snapshot.value.toString());
    String title;
    String type;
    String content;
    String date;

    if (num > 10 && num != 0) {
      for (int i = num; i > num - 10; i--) {
        final titleRef = FirebaseDatabase.instance.ref();
        final dateRef = FirebaseDatabase.instance.ref();
        final contentRef = FirebaseDatabase.instance.ref();
        final typeRef = FirebaseDatabase.instance.ref();

        final title_snapshot = await titleRef
            .child("users")
            .child(usersUID)
            .child("writing")
            .child(i.toString())
            .child("title")
            .get();
        final date_snapshot = await dateRef
            .child("users")
            .child(usersUID)
            .child("writing")
            .child(i.toString())
            .child("date")
            .get();
        final content_snapshot = await contentRef
            .child("users")
            .child(usersUID)
            .child("writing")
            .child(i.toString())
            .child("content")
            .get();
        final type_snapshot = await typeRef
            .child("users")
            .child(usersUID)
            .child("writing")
            .child(i.toString())
            .child("type")
            .get();
        title = title_snapshot.value.toString();
        content = content_snapshot.value.toString();
        date = convertDateFormat(date_snapshot.value.toString());
        type = type_snapshot.value.toString();
        print("Load Success");
        if (type == "보도자료") {
          type = 'assets/images/index/report.png';
        } else if (type == "반성문") {
          type = 'assets/images/index/reflection.png';
        } else if (type == "독서록") {
          type = 'assets/images/index/booklog.png';
        } else {
          type = 'assets/images/index/litigation.png';
        }
        gludList.add(
          Glud(
            title: title,
            date: date,
            imagePath: type,
            content: content,
            completed: true,
            route: const ResultPage(),
            index: i,
          ),
        );
      }
    } else if (num <= 10 && num != 0) {
      for (int i = num; i > 0; i--) {
        final titleRef = FirebaseDatabase.instance.ref();
        final dateRef = FirebaseDatabase.instance.ref();
        final contentRef = FirebaseDatabase.instance.ref();
        final typeRef = FirebaseDatabase.instance.ref();

        final title_snapshot = await titleRef
            .child("users")
            .child(usersUID)
            .child("writing")
            .child(i.toString())
            .child("title")
            .get();
        final date_snapshot = await dateRef
            .child("users")
            .child(usersUID)
            .child("writing")
            .child(i.toString())
            .child("date")
            .get();
        final content_snapshot = await contentRef
            .child("users")
            .child(usersUID)
            .child("writing")
            .child(i.toString())
            .child("content")
            .get();
        final type_snapshot = await typeRef
            .child("users")
            .child(usersUID)
            .child("writing")
            .child(i.toString())
            .child("type")
            .get();
        title = title_snapshot.value.toString();
        content = content_snapshot.value.toString();
        date = convertDateFormat(date_snapshot.value.toString());
        type = type_snapshot.value.toString();
        print("Load Success");
        if (type == "보도자료") {
          type = 'assets/images/index/report.png';
        } else if (type == "반성문") {
          type = 'assets/images/index/reflection.png';
        } else if (type == "독서록") {
          type = 'assets/images/index/booklog.png';
        } else {
          type = 'assets/images/index/litigation.png';
        }
        gludList.add(
          Glud(
            title: title,
            date: date,
            imagePath: type,
            content: content,
            completed: true,
            route: const ResultPage(),
            index: i,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await fillwrite();
    setState(() {
      // This will trigger a rebuild of the widget with the loaded data.
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView.builder(
                itemCount: gludList.length,
                itemBuilder: (context, index) =>
                    buildGludContainer(context, gludList[index]),
              ),
            ),
          ),
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

  Widget buildGludContainer(BuildContext context, Glud glud) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
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
                          glud.title,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          glud.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 15, color: Color(0xFF5E5E5E)),
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

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: statusbarStyle,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        iconSize: 20,
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '내가 작성한 글',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      titleSpacing: -10,
      toolbarHeight: 100,
    );
  }
}

class Glud {
  final String title;
  final String date;
  final String imagePath;
  final String content;
  final bool completed;
  final Widget route;
  final int index;

  Glud({
    required this.title,
    required this.date,
    required this.imagePath,
    required this.content,
    required this.completed,
    required this.route,
    required this.index,
  });
}

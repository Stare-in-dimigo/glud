import 'package:flutter/material.dart';

import '../widgets.dart';
import 'resultpage.dart';

class GludListPage extends StatefulWidget {
  const GludListPage({Key? key}) : super(key: key);

  @override
  _GludListPageState createState() => _GludListPageState();
}

class _GludListPageState extends State<GludListPage> {
  List<Glud> gludList = [
    Glud(
        title: '보도자료 제목',
        date: '2023-06-10',
        imagePath: 'assets/images/index/report.png',
        content: '내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용',
        completed: true,
        route: const ResultPage()),
  ];

  @override
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
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              if (glud.completed)
                Image.asset(glud.imagePath, height: 80)
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
              const SizedBox(width: 15),
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
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
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
                      right: 0,
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
      systemOverlayStyle: whitestyle,
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
          '최근 작성한 글',
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

  Glud({
    required this.title,
    required this.date,
    required this.imagePath,
    required this.content,
    required this.completed,
    required this.route,
  });
}

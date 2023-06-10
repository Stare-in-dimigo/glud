import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets.dart';

class GludListPage extends StatefulWidget {
  GludListPage({Key? key}) : super(key: key);

  @override
  _GludListPageState createState() => _GludListPageState();
}

class _GludListPageState extends State<GludListPage> {

  List<Glud> gludList = [
    Glud(title: '보도자료 제목', date: '2023-06-10', imagePath: 'assets/images/index/report.png', content: '내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용', completed: true),
    Glud(title: '독서록 제목', date: '2023-06-10', imagePath: 'assets/images/index/booklog.png', content: '내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용', completed: false),
    Glud(title: '소송문 제목', date: '2023-06-10', imagePath: 'assets/images/index/litigation.png', content: '내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용', completed: true),
    Glud(title: '반성문 제목', date: '2023-06-10', imagePath: 'assets/images/index/reflection.png', content: '내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용', completed: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView.builder(
            itemCount: gludList.length,
            itemBuilder: (context, index) => buildGludContainer(context, gludList[index]),
          ),
        ),
      ),
    );
  }

  Widget buildGludContainer(BuildContext context, Glud glud) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: CustomContainer(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            if (glud.completed)
              Image.asset(glud.imagePath, height: 80)
            else const SizedBox(
              width: 80,
              height: 80,
              child: Padding(
                padding: EdgeInsets.all(15.0),  // 원하는 패딩 값
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  color: Color(0xFFC0CFDB),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          glud.title,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          )
                      ),
                      Text(
                          glud.date,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey
                          )
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    glud.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        iconSize: 20,
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: const Text(
        '보도자료',
        style: TextStyle(
          color: Colors.black,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
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
  final bool completed; // New field

  Glud({
    required this.title,
    required this.date,
    required this.imagePath,
    required this.content,
    required this.completed, // Initialize new field
  });
}

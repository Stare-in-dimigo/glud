import 'package:flutter/material.dart';

import '../widgets.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomContainer(
                  padding: const EdgeInsets.fromLTRB(25, 20, 15, 20),
                  child: Row(
                    children: [
                      Image.asset('assets/images/notice_icon.png', width: 25),
                      const SizedBox(width: 15),
                      const Text('글루드 업데이트 안내',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Color(0xFF5E5E5E),
                          )),
                    ],
                  )),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomContainer(
                  padding: const EdgeInsets.fromLTRB(25, 20, 15, 20),
                  child: Row(
                    children: [
                      Image.asset('assets/images/notice_icon.png', width: 25),
                      const SizedBox(width: 15),
                      const Text('글루드 업데이트 안내',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Color(0xFF5E5E5E),
                          )),
                    ],
                  )),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black12, width: 1.0), // 이 부분에서 회색 보더를 정의합니다.
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 20, 15, 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('글루드 서버 점검 안내',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Color(0xFF5E5E5E),
                          )),
                    ),
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black12, width: 1.0), // 이 부분에서 회색 보더를 정의합니다.
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 20, 15, 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('글루드 서버 점검 안내',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Color(0xFF5E5E5E),
                          )),
                    ),
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black12, width: 1.0), // 이 부분에서 회색 보더를 정의합니다.
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 20, 15, 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('글루드 서버 점검 안내',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Color(0xFF5E5E5E),
                          )),
                    ),
                  )
              ),
            ),
          ],
        ));
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
          '공지사항',
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

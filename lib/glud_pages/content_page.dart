import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glud/login_pages/loginpage.dart' as user;
import 'package:glud/utility_pages/glud_list_page.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../widgets.dart';

String writingcontent = "";
String writingcontents = "";
GlobalKey<_ResultPageState> myGlobalKey = GlobalKey<_ResultPageState>();

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final usersRef = FirebaseDatabase.instance.ref();
  String type = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchLatestContent() async {
    final snapshot = await usersRef
        .child("users")
        .child(user.usersUID)
        .child("writing")
        .child(globalIndex.toString())
        .child("content")
        .get();
    final typesnapshot = await usersRef
        .child("users")
        .child(user.usersUID)
        .child("writing")
        .child(globalIndex.toString())
        .child("type")
        .get();
    writingcontent = snapshot.value.toString();
    writingcontents = snapshot.value.toString();
    type = typesnapshot.value.toString();
    String pattern = r"content:([^}]+)";
    RegExp regExp = RegExp(pattern);
    Match? match = regExp.firstMatch(writingcontent);
    if (match != null) {
      String extractedContent = match.group(1) ?? "Content not found";

      extractedContent = extractedContent.trim();

      if (extractedContent.endsWith("}}")) {
        extractedContent =
            extractedContent.substring(0, extractedContent.length - 2);
      }

      writingcontent = extractedContent;
    } else {
      writingcontent = "Content not found";
    }
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: writingcontents));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("클립보드에 복사되었습니다.")),
    );
  }

  void saveDocs() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("기능을 준비 중이에요!")),
    );
  }

  int checkspeaking = 0;
  void startspeaking() {
    final FlutterTts tts = FlutterTts();
    final TextEditingController controller =
        TextEditingController(text: writingcontents);
    if (checkspeaking == 0) {
      checkspeaking = 1;
      tts.setLanguage('kor');
      tts.setSpeechRate(0.4);
      tts.speak(controller.text);
    } else {
      checkspeaking = 0;
      tts.stop();
    }
  }

  void stopspeaking() {
    final FlutterTts tts = FlutterTts();
    checkspeaking = 0;
    tts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchLatestContent(),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView(
                children: [
                  CustomContainer(
                    child: Text(
                      writingcontents,
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Color(0xFF5E5E5E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: copyToClipboard,
                    child: const CustomContainer(
                        backgroundColor: Color(0xFF9D9D9D),
                        child: Center(
                          child: Text(
                            '클립보드에 복사하기',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: startspeaking,
                    child: const CustomContainer(
                        backgroundColor: Color(0xFF7EAAC9),
                        child: Center(
                          child: Text(
                            '글루드가 읽어주기',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: statusbarStyle,
      leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          iconSize: 20,
          onPressed: () {
            stopspeaking();
            Navigator.of(context).pop();
          }),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "내가 작성한 글",
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

import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:glud/index/voice_menu.dart';
import 'package:glud/widgets.dart';

import 'firebase_options.dart';
import 'index/menu.dart';
import 'index/profile.dart';
import 'login_pages/loginpage.dart';

const apiKey = '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';
const apiUrl = 'https://api.openai.com/v1/chat/completions';

bool isLoggedIn = false;
bool isDisabled = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (Platform.isAndroid) {
      await FlutterDisplayMode.setHighRefreshRate();
    }
  }

  runApp(const GludApp());
}

class GludApp extends StatefulWidget {
  const GludApp({Key? key}) : super(key: key);

  @override
  _GludAppState createState() => _GludAppState();
}

class _GludAppState extends State<GludApp> {
  int _selectedIndex = 0;
  final _pageController = PageController();

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void login() {
    setState(() {
      isLoggedIn = true;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> checkIsDisabled() async {
    final usersRef = FirebaseDatabase.instance.ref();
    final snapshot = await usersRef.child('users/$usersUID/isDisabled').get();
    if (snapshot.value is bool) {
      return snapshot.value as bool;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final appBarTitle = ['글루드', '마이페이지'][_selectedIndex];

    if (!isLoggedIn) {
      return FlutterWebFrame(
        builder: (context) {
          return MaterialApp(
            theme: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              fontFamily: 'Pretendard',
            ),
            home: LoginPage(onLogin: login),
          );
        },
        clipBehavior: Clip.hardEdge,
        maximumSize: Size(475.0, 812.0),
        enabled: kIsWeb,
        backgroundColor: Color(0xFF7EAAC9),
      );
    }

    return FlutterWebFrame(
      builder: (context) {
        return MaterialApp(
          theme: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            fontFamily: 'Pretendard',
          ),
          home: Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(text: appBarTitle),
            body: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  children: <Widget>[
                    FutureBuilder<bool>(
                      future: checkIsDisabled(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data == true) {
                          // return VoiceMenu();
                          return Menu();
                        } else {
                          return Menu();
                        }
                      },
                    ),
                    Profile(),
                  ],
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: kIsWeb
                        ? 65
                        : Platform.isAndroid
                            ? 65
                            : 85,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: const Color(0xFF92B4CD),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.border_color_rounded,
                              color: _selectedIndex == 0
                                  ? Colors.white
                                  : Colors.grey,
                              size: 30,
                            ),
                            onPressed: () {
                              _pageController.animateToPage(0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.person_rounded,
                              color: _selectedIndex == 1
                                  ? Colors.white
                                  : Colors.grey,
                              size: 30,
                            ),
                            onPressed: () {
                              _pageController.animateToPage(1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      clipBehavior: Clip.hardEdge,
      maximumSize: Size(475.0, 812.0),
      enabled: kIsWeb,
      backgroundColor: Color(0xFF7EAAC9),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  const CustomAppBar({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    if (text == '글루드') {
      actions = [
        Container(
          margin: const EdgeInsets.only(right: 25.0, top: 15.0),
          child: Image.asset(
            'assets/images/index/higlud.png',
            width: 170,
          ),
        ),
      ];
    }

    return AppBar(
      systemOverlayStyle: statusbarStyle,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      actions: actions,
      toolbarHeight: 100,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100.0);
}

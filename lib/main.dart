import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:glud/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_options.dart';
import 'index/gludindex.dart';
import 'index/profile.dart';
import 'login_pages/loginpage.dart';

const apiKey = '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';
const apiUrl = 'https://api.openai.com/v1/completions';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  GoogleSignIn(clientId: DefaultFirebaseOptions.currentPlatform.iosClientId).signIn();

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

  bool isLoggedIn = false;

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

  @override
  Widget build(BuildContext context) {
    final appBarTitle = ['글루드', '마이페이지'][_selectedIndex];

    if (!isLoggedIn) {
      return MaterialApp(
        theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          fontFamily: 'Pretendard',
        ),
        home: LoginPage(onLogin: login),
      );
    }

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
                GludIndex(),
                Profile(),
              ],
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomNavigationBar(
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
            ),
          ],
        ),
      ),
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
          margin: const EdgeInsets.only(right: 20.0, top: 15.0),
          child: Image.asset(
            'assets/images/index/higlud.png',
            width: 220,
          ),
        ),
      ];
    }

    return AppBar(
      systemOverlayStyle: bluestyle,
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

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  CustomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: Platform.isAndroid ? 80 : 100,
      padding: const EdgeInsets.all(15.0),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      ),
      backgroundColor: const Color(0xFF92B4CD),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            onTap: () => onTap(0),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.border_color_rounded,
                  size: 30,
                  color: selectedIndex == 0
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFFE5E5E5),
                ),
                const SizedBox(height: 3.0),
                Text(
                  '글루드',
                  style: TextStyle(
                    color: selectedIndex == 0
                        ? const Color(0xFFFFFFFF)
                        : const Color(0xFFE5E5E5),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onTap(1),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.person_rounded,
                  size: 30,
                  color: selectedIndex == 1
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFFE5E5E5),
                ),
                const SizedBox(height: 3.0),
                Text(
                  '마이페이지',
                  style: TextStyle(
                    color: selectedIndex == 1
                        ? const Color(0xFFFFFFFF)
                        : const Color(0xFFE5E5E5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

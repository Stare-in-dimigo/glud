import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'dart:io' show Platform;
import 'index/gludindex.dart';
import 'index/profile.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid || Platform.isIOS) {
    await FlutterDisplayMode.setHighRefreshRate();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTitle = ['글루드', '마이페이지'][_selectedIndex];

    return MaterialApp(
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(text: appBarTitle),
        body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: PageView(
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
        ),
        bottomNavigationBar: CustomNavigationBar(
          selectedIndex: _selectedIndex,
          onTap: _onItemTapped,
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
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Color(0xFF92B4CD),
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          )
        ),
      ),
      toolbarHeight: 100,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100.0);
}

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      child: Container(
        height: 70,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xFFB1B8C0),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF92B4CD),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.border_color_rounded),
              label: '글루드',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: '마이페이지',
            ),
          ],
          currentIndex: selectedIndex,
          unselectedItemColor: const Color(0xFFE5E5E5),
          selectedItemColor: const Color(0xFFFFFFFF),
          onTap: onTap,
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../login_pages/loginpage.dart';
import '../main.dart';
import '../widgets.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isGluedModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _isGluedModeEnabled = isDisabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          children: [
            buildSettingsItem('글루드 모드', _isGluedModeEnabled),
            buildLogoutButton(context),
          ],
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
      title: _isGluedModeEnabled
          ? const Text(
              '설정',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            )
          : const Text(
              '설정',
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

  Widget buildSettingsItem(String item, bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomContainer(
        padding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Color(0xFF5E5E5E),
                )),
            Switch(
              value: _isGluedModeEnabled,
              activeColor: const Color(0xFF7EAAC9),
              onChanged: (value) {
                setState(() {
                  _isGluedModeEnabled = value;
                  isDisabled = _isGluedModeEnabled;
                  print(isDisabled);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
      child: ElevatedButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
          usersUID = "";
          usersEmail = "";
          exit(0);
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          onPrimary: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: const Text('앱 종료 및 로그아웃', style: TextStyle(fontSize: 18.0)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  final settingsItems = ['푸시 알림', '색약 모드', '다크 모드'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          children:
              settingsItems.map((item) => buildSettingsItem(item)).toList(),
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

  Widget buildSettingsItem(String item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: SettingsItem(
        text: item,
      ),
    );
  }
}

class SettingsItem extends StatefulWidget {
  final String text;

  const SettingsItem({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  _SettingsItemState createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomContainer(
        padding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Color(0xFF5E5E5E),
                )
            ),
            Switch(
              value: _isSwitched,
              activeColor: const Color(0xFF7EAAC9),
              onChanged: (value) {
                setState(() {
                  _isSwitched = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  final settingsItems = ['index0', 'index1', 'index2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F6),
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
      automaticallyImplyLeading: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Color(0xFFF2F4F6),
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: const Text('설정', style: titleTextStyle),
      actions: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xFFB1B8C0),
          iconSize: 25.0,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget buildSettingsItem(String item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
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
    return CustomContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.text, style: regularTextStyle),
          Switch(
            value: _isSwitched,
            activeColor: const Color(0xFF6685F2),
            onChanged: (value) {
              setState(() {
                _isSwitched = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

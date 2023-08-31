import 'package:flutter/material.dart';

class VoiceMenu extends StatelessWidget {
  VoiceMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/index/higlud.png',
            width: 300,
          ),
          SizedBox(height: 100)
        ],
      )
    );
  }
}
import 'package:flutter/material.dart';

import '../widgets.dart';

class LaboratoryPage extends StatelessWidget {
  LaboratoryPage({Key? key}) : super(key: key);

  final settingsItems = ['조용한 글루드', '시끄러운 스텔스', '이상한 스테어'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/laboratory.png',
                    height: 80,
                  ),
                  const SizedBox(height: 30),
                  const Center(
                    child: Column(children: [
                      Text(
                        '기능을 준비 중이에요',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '실험실 기능은 추후 이용하실 수 있어요',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9D9D9D),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const CustomContainer(
                    backgroundColor: Color(0xFF7EAAC9),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '돌아가기',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
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
          '실험실',
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
import 'package:flutter/material.dart';

import '../widgets.dart';
import 'gludlist.dart';

class FinishPage extends StatefulWidget {
  const FinishPage({Key? key}) : super(key: key);

  @override
  _FinishPageState createState() => _FinishPageState();
}

class _FinishPageState extends State<FinishPage> {
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
                  const Center(
                    child: Text(
                      '글루드가 쓴\n 생생한 보도자료를\n 확인해 보세요!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5E5E5E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Image.asset(
                    'assets/images/index/report.png',
                    height: 150,
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                InkWell(
                  onTap: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const GludListPage())),
                  child: const CustomContainer(
                    backgroundColor: Color(0xFF7EAAC9),
                    child: Center(
                      child: Text(
                        '확인하러 가기',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const CustomContainer(
                    backgroundColor: Color(0xFFE5E5E5),
                    child: Center(
                      child: Text(
                        '나중에 할게요',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5E5E5E),
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
      toolbarHeight: 100,
    );
  }
}

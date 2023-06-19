import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int selectedButtonIndex = -1;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(whitestyle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  const Center(
                    child: Column(children: [
                      Text(
                        '혹시 장애를 갖고 계시거나\n타자를 치기 불편하신가요?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '글루드가 더 나은 환경을 제공해 드릴 수 있어요',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9D9D9D),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 100),
                  Image.asset(
                    'assets/images/loginpage/keyboard.png',
                    height: 100,
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
                  onTap: selectedButtonIndex == -1
                      ? () {
                          setState(() {
                            selectedButtonIndex = 0;
                          });
                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.of(context).pop(true);
                          });
                        }
                      : null,
                  child: CustomContainer(
                    backgroundColor: selectedButtonIndex == 0
                        ? const Color(0xFF7EAAC9)
                        : const Color(0xFFF5F5F5),
                    child: Text(
                      '네, 타자를 치기에 어려움이 있어요',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: selectedButtonIndex == 0
                            ? Colors.white
                            : const Color(0xFF5E5E5E),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: selectedButtonIndex == -1
                      ? () {
                          setState(() {
                            selectedButtonIndex = 1;
                          });
                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.of(context).pop(false);
                          });
                        }
                      : null,
                  child: CustomContainer(
                    backgroundColor: selectedButtonIndex == 1
                        ? const Color(0xFF7EAAC9)
                        : const Color(0xFFF5F5F5),
                    child: Text(
                      '아니요, 타자를 치기에 어려움이 없어요',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: selectedButtonIndex == 1
                            ? Colors.white
                            : const Color(0xFF5E5E5E),
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
}

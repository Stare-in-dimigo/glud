import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets.dart';
import 'resultpage.dart';

class ReportPage extends StatelessWidget {
  ReportPage({Key? key}) : super(key: key);

  final dateController = TextEditingController();
  final placeController = TextEditingController();
  final mainContentController = TextEditingController();
  final quoteController = TextEditingController();

  Future<void> generatePressRelease(BuildContext context) async {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Center(
            child: Text(
            '로딩중..',
            style: titleTextStyle,
            ),
          ),
        );
      },
    );

    final response = await http.post(
      Uri.parse('http://0.0.0.0:5000/generate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'date': dateController.text,
        'place': placeController.text,
        'main_content': mainContentController.text,
        'quote': quoteController.text,
      }),
    );

    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then parse the JSON.
      final result = jsonDecode(response.body);
      Navigator.push(
          context,
          Navigator.of(context).push(FadeRoute(page: ResultPage(generated_text: result['generated_text']))) as Route<Object?>
      );
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to generate press release');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF2F4F6),
        appBar: buildAppBar(context),
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            children: [
              CustomContainer(
                child: Center(
                  child: CustomTextField(
                      controller: dateController,
                      hintText: '일시'
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CustomContainer(
                child: Center(
                  child: CustomTextField(
                    controller: placeController,
                    hintText: '장소'
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CustomContainer(
                child: Center(
                  child: CustomTextField(
                    controller: mainContentController,
                    hintText: '주요 내용'
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CustomContainer(
                child: Center(
                  child: CustomTextField(
                    controller: quoteController,
                    hintText: '인용문'
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const CustomContainer(
                child: Center(
                  child: Text(
                    '이미지 업로드',
                    style: regularTextStyle,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  generatePressRelease(context);
                },
                child: const CustomContainer(
                  backgroundColor: Color(0xFFB1B8C0),
                  child: Center(
                    child: Text(
                      '보도자료 만들기',
                      style: buttonTextStyle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ));
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
      title: const Text('보도자료', style: titleTextStyle),
      actions: [
        IconButton(
          icon: const Icon(Icons.lightbulb),
          color: const Color(0xFFB1B8C0),
          iconSize: 25.0,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    '팁',
                    style: titleTextStyle,
                  ),
                  content: const Text(
                    '팁 내용',
                    style: regularTextStyle,
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFB1B8C0),
                      ),
                      child: const Text('확인'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xFFB1B8C0),
          iconSize: 25.0,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const CustomTextField({
    Key? key,
    this.hintText = '',
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: null,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: regularTextStyle,
        border: InputBorder.none,
        alignLabelWithHint: true,
      ),
      style: regularTextStyle,
      textAlign: TextAlign.center,
    );
  }
}

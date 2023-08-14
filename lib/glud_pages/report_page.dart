import 'dart:convert';

import 'package:firebase_database/firebase_database.dart'; // Firebase Realtime Database 라이브러리 추가
import 'package:flutter/material.dart';
import 'package:glud/glud_pages/finish_page.dart';
import 'package:glud/login_pages/loginpage.dart' as user;
import 'package:http/http.dart' as http;

import '../main.dart';
import '../widgets.dart';

String content = "";
String date = "";
String place = "";
String quote = "";

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _quoteController = TextEditingController();

  bool _isFocused = false;

  @override
  void dispose() {
    _dateTimeController.dispose();
    _placeController.dispose();
    _contentController.dispose();
    _quoteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_onContentChanged);
    _dateTimeController.addListener(_onContentChanged);
    _placeController.addListener(_onContentChanged);
    _quoteController.addListener(_onContentChanged);
  }

  void _onContentChanged() {
    setState(() {
      content = _contentController.text;
      date = _dateTimeController.text;
      place = _placeController.text;
      quote = _quoteController.text;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1500),
      lastDate: DateTime(2500),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF92B4CD),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateTimeController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          _isFocused = false;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView(
              children: [
                _buildCustomContainer(
                  Icons.calendar_today,
                  '일시',
                  _dateTimeController,
                ),
                const SizedBox(height: 15),
                _buildCustomContainer(
                  Icons.place_outlined,
                  '장소',
                  _placeController,
                ),
                const SizedBox(height: 15),
                _buildCustomContainer(
                  null,
                  '\n\n주요 내용\n\n',
                  _contentController,
                  centerAlign: true,
                ),
                const SizedBox(height: 15),
                _buildCustomContainer(
                  Icons.format_quote_outlined,
                  '인용문',
                  _quoteController,
                ),
                const SizedBox(height: 85),
              ],
            ),
          ),
        ),
        floatingActionButton: _buildFloatingButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  CustomContainer _buildCustomContainer(
    IconData? icon,
    String hintText,
    TextEditingController controller, {
    bool centerAlign = false,
  }) {
    return CustomContainer(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Row(
        children: [
          if (icon != null)
            Icon(icon, color: const Color(0xFFC0CFDB), size: 30.0),
          if (icon != null) const SizedBox(width: 15),
          Expanded(
            child: hintText == '일시'
                ? _buildDateTimeField()
                : CustomTextField(
                    hintText: hintText,
                    centerAlign: centerAlign,
                    textEditingController: controller,
                    onFocusChange: (bool focused) {
                      setState(() {
                        _isFocused = focused;
                      });
                    },
                  ),
          ),
        ],
      ),
    );
  }

  TextField _buildDateTimeField() {
    return TextField(
      controller: _dateTimeController,
      decoration: const InputDecoration(
        hintText: '일시',
        hintStyle: TextStyle(
          color: Color(0xFF5E5E5E),
          fontSize: 20.0,
        ),
        border: InputBorder.none,
      ),
      style: const TextStyle(
        color: Color(0xFF5E5E5E),
        fontSize: 20.0,
      ),
      readOnly: true,
      onTap: () {
        _selectDate(context);
      },
    );
  }

  Widget _buildFloatingButton(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: !_isFocused
          ? const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              key: ValueKey<int>(1),
              child: CustomFloatingButton(
                text: '보도자료 생성하기',
              ),
            )
          : const SizedBox.shrink(key: ValueKey<int>(2)),
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
          '보도자료',
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

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool centerAlign;
  final TextEditingController textEditingController;
  final Function(bool) onFocusChange;

  const CustomTextField({
    Key? key,
    this.hintText = '',
    this.centerAlign = false,
    required this.textEditingController,
    required this.onFocusChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: const Color(0xFF5E5E5E),
      maxLines: null,
      controller: textEditingController,
      onChanged: (text) {},
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF5E5E5E),
          fontSize: 20.0,
        ),
        border: InputBorder.none,
        alignLabelWithHint: true,
      ),
      style: const TextStyle(
        color: Color(0xFF5E5E5E),
        fontSize: 20.0,
      ),
      textAlign: centerAlign ? TextAlign.center : TextAlign.left,
      onTap: () {
        onFocusChange(true);
      },
      onEditingComplete: () {
        onFocusChange(false);
      },
      onSubmitted: (text) {
        onFocusChange(false);
      },
    );
  }
}

class CustomFloatingButton extends StatelessWidget {
  final String text;

  const CustomFloatingButton({Key? key, required this.text}) : super(key: key);

  Future<String> generateText(String prompt) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode({
        "model": "text-davinci-003",
        'prompt': prompt,
        'max_tokens': 1000,
        'temperature': 0,
        'top_p': 1,
        'frequency_penalty': 0,
        'presence_penalty': 0
      }),
    );

    Map<String, dynamic> newresponse =
        jsonDecode(utf8.decode(response.bodyBytes));

    return newresponse['choices'][0]['text'];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                // 모서리에 곡률을 줍니다
                borderRadius: BorderRadius.circular(15), // 곡률의 정도를 조절합니다
              ),
              child: Container(
                width: 200, // Dialog의 너비를 지정합니다
                padding: const EdgeInsets.all(40),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30.0, // 원하는 높이
                      width: 30.0, // 원하는 너비
                      child: CircularProgressIndicator(
                        color: Color(0xFFC0CFDB),
                        strokeWidth: 4.0,
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      '로딩중...',
                      style: TextStyle(
                        color: Color(0xFF5E5E5E),
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );

        String prompt =
            "일시 : $date, 장소 : $place, 주요내용 : $content, 인용문 : $quote 다음 정보를 가지고 보도자료 작성해줘";
        String contents = await generateText(prompt);

        Navigator.of(context).pop(); // 로딩 창 닫기

        DateTime now = DateTime.now();
        String timestamp = now.toString();
        DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
        databaseReference
            .child("users")
            .child(user.usersUID)
            .child("writing")
            .push()
            .set({
          "content": contents,
          "time": timestamp,
          "type": "보도자료",
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FinishPage()),
        );
      },
      child: CustomContainer(
        height: 70,
        backgroundColor: const Color(0xFF7EAAC9),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

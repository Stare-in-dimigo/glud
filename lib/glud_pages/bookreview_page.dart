import 'dart:convert';

import 'package:firebase_database/firebase_database.dart'; // Firebase Realtime Database 라이브러리 추가
import 'package:flutter/material.dart';
import 'package:glud/glud_pages/finish_page.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../widgets.dart';
import '../login_pages/loginpage.dart';

String writer = "";
String date = "";
String publisher = "";
String bookname = "";

class BookreviewPage extends StatefulWidget {
  const BookreviewPage({Key? key}) : super(key: key);

  @override
  _BookreviewPageState createState() => _BookreviewPageState();
}

class _BookreviewPageState extends State<BookreviewPage> {
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _writerController = TextEditingController();
  final TextEditingController _booknameController = TextEditingController();

  bool _isFocused = false;

  @override
  void dispose() {
    _dateTimeController.dispose();
    _publisherController.dispose();
    _writerController.dispose();
    _booknameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _writerController.addListener(_onContentChanged);
    _dateTimeController.addListener(_onContentChanged);
    _publisherController.addListener(_onContentChanged);
    _booknameController.addListener(_onContentChanged);
  }

  void _onContentChanged() {
    setState(() {
      writer = _writerController.text;
      date = _dateTimeController.text;
      publisher = _publisherController.text;
      bookname = _booknameController.text;
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
                  '날짜',
                  _dateTimeController,
                ),
                const SizedBox(height: 15),
                _buildCustomContainer(
                  Icons.account_balance_outlined,
                  '출판사',
                  _publisherController,
                ),
                const SizedBox(height: 15),
                _buildCustomContainer(
                  Icons.edit_outlined,
                  '작가명',
                  _writerController,
                ),
                const SizedBox(height: 15),
                _buildCustomContainer(
                  Icons.book_outlined,
                  '책 제목',
                  _booknameController,
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
            child: hintText == '날짜'
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
        hintText: '날짜',
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
          text: '독서록 생성하기',
        ),
      )
          : const SizedBox.shrink(key: ValueKey<int>(2)),
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
      title: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '독서록',
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
      Uri.parse(apiUrl), // Ensure this URL points to v1/chat/completions
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        'messages': [
          {"role": "system", "content": "You are a Korean student. You're going to write an bookreview"},
          {"role": "user", "content": prompt}
        ]
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> newresponse =
      jsonDecode(utf8.decode(response.bodyBytes));

      if (newresponse != null &&
          newresponse.containsKey('choices') &&
          newresponse['choices'].isNotEmpty &&
          newresponse['choices'][0].containsKey('message')) {
        return newresponse['choices'][0]['message']['content'];
      } else {
        print("Response Body: ${response.body}");
        throw Exception('Unexpected response structure from the API');
      }
    } else {
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      // Use ScaffoldMessenger or another method to show an error message
      throw Exception('Failed to load data from the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const CustomLoading();
          },
        );

        final usersRef = FirebaseDatabase.instance.ref();
        final snapshot =
        await usersRef.child("users").child(usersUID).child("num").get();

        int num = int.parse(snapshot.value.toString()) + 1;

        final DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(usersUID);

        await userRef.child('num').set(num);
        DatabaseReference newItemRef =
        userRef.child('writing').child(num.toString());

        String prompt =
            'Write a bookreview based on the information: date: $date, publisher: $publisher, writer: $writer, bookname: $bookname.'
            'The essential contents to include are the title, date, a summary of the book, and your opinion. Except for the title, write everything in a single paragraph.'
            'You can exaggerate the information I provided, but never add details not inferred from the information given. Please write in Korean.';
        String contents = await generateText(prompt);
        String titlePrompt = "Please write a Korean title for this content. $prompt.";
        String title = await generateText(titlePrompt);

        Navigator.of(context).pop(); // 로딩 창 닫기

        DateTime now = DateTime.now();
        String timestamp = now.toString();
        DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
        databaseReference
            .child("users")
            .child(usersUID)
            .child("writing")
            .child(num.toString())
            .set({
          "title": title,
          "content": contents,
          "date": timestamp,
          "type": "독서록",
        });
        databaseReference.child("users").child(usersUID).child("num").set(num);

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

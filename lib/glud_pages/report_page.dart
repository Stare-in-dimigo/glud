import 'dart:convert';

import 'package:firebase_database/firebase_database.dart'; // Firebase Realtime Database 라이브러리 추가
import 'package:flutter/material.dart';
import 'package:glud/glud_pages/finish_page.dart';
import 'package:http/http.dart' as http;

import '../login_pages/loginpage.dart';
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
                  '주요 내용\n\n\n\n',
                  _contentController,
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
        "model": "gpt-3.5-turbo",
        'messages': [
          {
            "role": "system",
            "content":
                "You are a Korean journalist tasked with writing an article."
          },
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
            'Create a article in Korean based on the following details: An incident occurred at $place on $date, involving $content.'
            'A pivotal figure in the event stated, "$quote". The press release should include a headline, the date, and a concise paragraph summarizing the incident.'
            'While you may enhance the given information for dramatic effect, do not introduce any new details beyond what is inferred from the provided information.';
        String contents = await generateText(prompt);

        Navigator.of(context).pop();

        DateTime now = DateTime.now();
        String timestamp = now.toString();
        DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
        databaseReference
            .child("users")
            .child(usersUID)
            .child("writing")
            .child(num.toString())
            .set({
          "content": contents,
          "date": timestamp,
          "type": "보도자료",
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

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:glud/glud_pages/finish_page.dart';
import 'package:http/http.dart' as http;

import '../login_pages/loginpage.dart';
import '../main.dart';
import '../widgets.dart';

String purpose = "";
String date = "";
String incident = "";
String cause = "";

class LitigationPage extends StatefulWidget {
  const LitigationPage({Key? key}) : super(key: key);

  @override
  _LitigationPageState createState() => _LitigationPageState();
}

class _LitigationPageState extends State<LitigationPage> {
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _incidentController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _causeController = TextEditingController();

  bool _isFocused = false;

  @override
  void dispose() {
    _dateTimeController.dispose();
    _incidentController.dispose();
    _purposeController.dispose();
    _causeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _purposeController.addListener(_onContentChanged);
    _dateTimeController.addListener(_onContentChanged);
    _incidentController.addListener(_onContentChanged);
    _causeController.addListener(_onContentChanged);
  }

  void _onContentChanged() {
    setState(() {
      purpose = _purposeController.text;
      date = _dateTimeController.text;
      incident = _incidentController.text;
      cause = _causeController.text;
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
                  Icons.search_outlined,
                  '사건',
                  _incidentController,
                ),
                const SizedBox(height: 15),
                _buildCustomContainer(
                  null,
                  '청구 취지\n\n\n\n',
                  _purposeController,
                ),
                const SizedBox(height: 15),
                _buildCustomContainer(
                  null,
                  '청구 원인\n\n\n\n',
                  _causeController,
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
          text: '소송문 생성하기',
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
          '소송문',
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
            "content": "You are a Korean attorney preparing to draft a lawsuit."
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
            'Draft a legal complaint in Korean regarding the $incident that occurred on $date. The lawsuit aims to achieve $purpose and is based on the cause: $cause.'
            'Key elements to include are the title, date of the incident, a brief description of the incident, the objective of the lawsuit, and the underlying cause. '
            'While you may amplify the given information, refrain from introducing any new details not suggested by the original information provided.';
        String contents = await generateText(prompt);

        String titlePrompt =
            "Please write a Korean title for this content. $prompt.";
        String title = await generateText(titlePrompt);

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
          "title": title,
          "content": contents,
          "date": timestamp,
          "type": "소송문",
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

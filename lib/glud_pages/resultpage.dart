import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets.dart';

class ResultPage extends StatelessWidget {
  final String generated_text;

  ResultPage({Key? key, required this.generated_text}) : super(key: key);

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
                  child: Text(
                    generated_text,
                    style: regularTextStyle,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const CustomContainer(
                backgroundColor: Color(0xFFB1B8C0),
                child: Center(
                  child: Text(
                    '클립보드에 복사하기',
                    style: buttonTextStyle,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const CustomContainer(
                backgroundColor: Color(0xFFB1B8C0),
                child: Center(
                  child: Text(
                    'Docx로 다운로드하기',
                    style: buttonTextStyle,
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
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xFFB1B8C0),
          iconSize: 25.0,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

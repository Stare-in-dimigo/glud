import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets.dart';

class ReportPage extends StatefulWidget {
  ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  TextEditingController _dateTimeController = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _quoteController = TextEditingController();

  bool _isDateTimeFocused = false;
  bool _isPlaceFocused = false;
  bool _isContentFocused = false;
  bool _isQuoteFocused = false;

  @override
  void dispose() {
    _dateTimeController.dispose();
    _placeController.dispose();
    _contentController.dispose();
    _quoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: GestureDetector(
        onTap: () {
          // 배경 터치 시 포커스 해제 및 입력 상태 종료
          FocusScope.of(context).unfocus();
          setState(() {
            _isDateTimeFocused = false;
            _isPlaceFocused = false;
            _isContentFocused = false;
            _isQuoteFocused = false;
          });
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView(
              children: [
                buildCustomContainer(
                  Icons.calendar_today,
                  '일시',
                  _dateTimeController,
                      (bool focused) {
                    setState(() {
                      _isDateTimeFocused = focused;
                    });
                  },
                ),
                const SizedBox(height: 15),
                buildCustomContainer(
                  Icons.place_outlined,
                  '장소',
                  _placeController,
                      (bool focused) {
                    setState(() {
                      _isPlaceFocused = focused;
                    });
                  },
                ),
                const SizedBox(height: 15),
                buildCustomContainer(
                  null,
                  '주요 내용',
                  _contentController,
                      (bool focused) {
                    setState(() {
                      _isContentFocused = focused;
                    });
                  },
                  centerAlign: true,
                ),
                const SizedBox(height: 15),
                buildCustomContainer(
                  Icons.format_quote_outlined,
                  '인용문',
                  _quoteController,
                      (bool focused) {
                    setState(() {
                      _isQuoteFocused = focused;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.only(
          top: _isDateTimeFocused || _isPlaceFocused || _isContentFocused || _isQuoteFocused ? MediaQuery.of(context).size.height : 0,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: CustomFloatingButton(text: '보도자료 생성하기'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  CustomContainer buildCustomContainer(
      IconData? icon,
      String hintText,
      TextEditingController controller,
      Function(bool) onFocusChange, {
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
            child: CustomTextField(
              hintText: hintText,
              centerAlign: centerAlign,
              textEditingController: controller,
              onFocusChange: onFocusChange,
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        iconSize: 20,
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: const Text(
        '보도자료',
        style: TextStyle(
          color: Colors.black,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      titleSpacing: -10,
      toolbarHeight: 100,
    );
  }

  Size get preferredSize => const Size.fromHeight(100.0);
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

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
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
    );
  }
}

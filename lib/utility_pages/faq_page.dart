import 'package:flutter/material.dart';

// 상황에 따라 CustomContainer 위젯과 whitestyle을 정의해야 할 수 있습니다.
import '../widgets.dart';

class FaqItem {
  final String question;
  final String answer;

  FaqItem(this.question, this.answer);
}

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<bool> expanded = [false, false, false, false];

  final List<FaqItem> faqItems = [
    FaqItem('다른 형식의 글은 쓸 수 없나요?', '없어용 없어용 없어용 없어용 ...'),
    FaqItem('어떻게 회원가입하나요?', '회원가입은 ...'),
    FaqItem('비밀번호를 잊어버렸어요', '비밀번호 재설정 ...'),
    FaqItem('어떻게 상품을 주문하나요?', '상품 주문은 ...'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < faqItems.length; i++)
              _buildFaqItem(i),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(int index) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Container(
              decoration: BoxDecoration(
                border: expanded[index]
                    ? null
                    : const Border(
                  bottom: BorderSide(
                      color: Colors.black12, width: 1.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(faqItems[index].question,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Color(0xFF5E5E5E),
                          )),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            expanded[index] = !expanded[index];
                          });
                        },
                        icon: Icon(
                          expanded[index]
                              ? Icons.close_rounded
                              : Icons.arrow_forward_ios_rounded,
                          color: const Color(0xFF9D9D9D),
                          size: 20,
                        ),
                      )
                    ]),
              )),
        ),
        if (expanded[index])
          Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
            child: CustomContainer(
              padding: EdgeInsets.fromLTRB(25, 20, 15, 20),
              child: Text(
                  faqItems[index].answer,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color(0xFF5E5E5E),
                  )),
            ),
          ),
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: whitestyle, // 정의되어 있어야 합니다.
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
          '자주 찾는 질문',
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
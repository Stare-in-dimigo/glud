import 'package:flutter/material.dart';

import '../widgets.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<bool> expanded = [false, false, false, false]; // 각 질문/답변 쌍의 상태를 저장합니다.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFaqItem(0),
            _buildFaqItem(1),
            _buildFaqItem(2),
            _buildFaqItem(3),
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
                      color: Colors.black12,
                      width: 1.0), // 회색 보더를 정의합니다.
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('다른 형식의 글은 쓸 수 없나요?',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Color(0xFF5E5E5E),
                          )),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            expanded[index] =
                            !expanded[index]; // 해당 index의 상태를 변경합니다.
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
        if (expanded[index]) // 답변이 확장되었다면 표시합니다.
          const Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
            child: CustomContainer(
              padding: EdgeInsets.fromLTRB(25, 20, 15, 20),
              child: Text(
                  '없어용 없어용 없어용 없어용 없어용 없어용 없어용 없어용 없어용 없어용 없어용 없어용 없어용 없어용 없어용 없어용 없어용 없어용 없어용 없어용 없어용 없어용 없어용 없어용 ',
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

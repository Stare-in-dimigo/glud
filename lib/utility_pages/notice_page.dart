import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets.dart';

class NoticeItem {
  final String question;
  final String answer;

  NoticeItem(this.question, this.answer);
}

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  List<bool> expanded = [false, false, false, false];

  final List<NoticeItem> faqItems = [
    NoticeItem('글루드 출시!', '글루드가 9월 21일 정식으로 출시되었습니다!'),
    NoticeItem('글루드 베타 출시!', '글루드 베타가 9월 14일 출시되었습니다!'),
  ];

  final List<NoticeItem> announcementItems = [
    NoticeItem('개인정보 처리방침 안내', 'glud.notion.site'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (final item in announcementItems) _buildAnnouncementItem(item),
            for (int i = 0; i < faqItems.length; i++) _buildNoticeItem(i),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementItem(NoticeItem item) {
    return GestureDetector(
      onTap: () async {
        final url = Uri(scheme: 'https', host: item.answer);

        if (!await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        )) {
          throw Exception('Could not launch $url');
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
        child: CustomContainer(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          child: Row(
            children: [
              Image.asset('assets/images/notice_icon.png', width: 25),
              const SizedBox(width: 10),
              Text(item.question,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Color(0xFF5E5E5E),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoticeItem(int index) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: GestureDetector(
              onTap: () {
                setState(() {
                  expanded[index] = !expanded[index];
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: expanded[index]
                      ? null
                      : const Border(
                          bottom: BorderSide(color: Colors.black12, width: 1.0),
                        ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 10, 20),
                  child: Row(children: [
                    Text(faqItems[index].question,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFF5E5E5E),
                        )),
                    Expanded(child: Container()),
                    if (!expanded[index])
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xFF9D9D9D),
                        size: 20,
                      ),
                  ]),
                ),
              )),
        ),
        if (expanded[index])
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 10),
            child: CustomContainer(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: Text(faqItems[index].answer,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Color(0xFF5E5E5E),
                  )),
            ),
          ),
      ],
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
          '공지사항',
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

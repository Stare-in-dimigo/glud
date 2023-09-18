import 'package:flutter/material.dart';

import '../glud_pages/bookreview_page.dart';
import '../glud_pages/litigationpage_page.dart';
import '../glud_pages/reflection_page.dart';
import '../glud_pages/report_page.dart';
import '../glud_pages/voice_page.dart';
import '../glud_pages/voice_page_teaser.dart';
import '../widgets.dart';
import 'package:glud/main.dart';

int globalwritingIndex = 0;

class Menu extends StatelessWidget {
  Menu({Key? key}) : super(key: key);

  final List<_GludItem> _items = [
    _GludItem('보도자료', '생생한', 'assets/images/index/report.png', ReportPage(), 0),
    _GludItem(
        '독서록', '동화같은', 'assets/images/index/booklog.png', BookreviewPage(), 1),
    _GludItem('반성문', '그럴듯한', 'assets/images/index/reflection.png',
        ReflectionPage(), 2),
    _GludItem('소송문', '백전백승', 'assets/images/index/litigation.png',
        LitigationPage(), 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: FutureBuilder<bool>(
        future: checkIsDisabled(),
        builder: (context, snapshot) {
          return GridView.count(
            crossAxisCount: snapshot.hasData && snapshot.data == false ? 2 : 1,
            childAspectRatio: 4 / 5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: _items.map((item) {
              return GestureDetector(
                onTap: () => _onItemTap(context, item),
                onLongPress: () => _onItemLongPress(context, item),
                child: CustomContainer(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: snapshot.hasData && snapshot.data == false ? 23 : 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5E5E5E),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          '글루드가 쓰는\n${item.explain} ${item.title}',
                          style: TextStyle(
                            fontSize: snapshot.hasData && snapshot.data == false ? 15 : 24,
                            color: Color(0xFF9D9D9D),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Image.asset(
                              item.image,
                              fit: BoxFit.contain,
                              height: 200,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }


  void _onItemTap(BuildContext context, _GludItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return FutureBuilder<bool>(
            future: checkIsDisabled(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == false) {
                return item.page;
              } else {
                return VoicePage();
              }
            },
          );
        },
      ),
    );
  }

  void _onItemLongPress(BuildContext context, _GludItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VoicePage(),
        //builder: (context) => VoicePageTeaser(),
      ),
    );
  }
}

class _GludItem {
  final String title;
  final String explain;
  final String image;
  final Widget page;
  final int writingindex;

  _GludItem(
    this.title,
    this.explain,
    this.image,
    this.page,
    this.writingindex,
  );
}

import 'package:flutter/material.dart';

import '../glud_pages/bookreview_page.dart';
import '../glud_pages/litigationpage_page.dart';
import '../glud_pages/reflection_page.dart';
import '../glud_pages/report_page.dart';
import '../glud_pages/voice_page.dart';
import '../widgets.dart';

class GludIndex extends StatelessWidget {
  GludIndex({Key? key}) : super(key: key);

  final List<_GludItem> _items = [
    _GludItem('보도자료', '생생한', 'assets/images/index/report.png', ReportPage()),
    _GludItem(
        '독서록', '동화같은', 'assets/images/index/booklog.png', BookreviewPage()),
    _GludItem(
        '반성문', '그럴듯한', 'assets/images/index/reflection.png', ReflectionPage()),
    _GludItem(
        '소송문', '백전백승', 'assets/images/index/litigation.png', LitigationPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: GridView.count(
        crossAxisCount: 2,
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
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5E5E5E),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      '글루드가 쓰는\n${item.explain} ${item.title}',
                      style: const TextStyle(
                        fontSize: 15,
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _onItemTap(BuildContext context, _GludItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => item.page,
      ),
    );
  }

  void _onItemLongPress(BuildContext context, _GludItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VoicePage(),
      ),
    );
  }
}

class _GludItem {
  final String title;
  final String explain;
  final String image;
  final Widget page;

  _GludItem(this.title, this.explain, this.image, this.page);
}

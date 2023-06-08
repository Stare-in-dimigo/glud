import 'package:flutter/material.dart';
import '../glud_pages/reportpage.dart';
import '../widgets.dart';
import 'settings.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);

  final List<_MypageItem> _items = [
    _MypageItem('최근 작성한 글', 'assets/images/mypage/recent.png', ReportPage()),
    _MypageItem('자주 찾는 질문', 'assets/images/mypage/faq.png', ReportPage()),
    _MypageItem('고객센터', 'assets/images/mypage/contact.png', ReportPage()),
    _MypageItem('실험실', 'assets/images/mypage/laboratory.png', ReportPage()),
    _MypageItem('공지사항', 'assets/images/mypage/notice.png', ReportPage()),
  ];

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 3;
    int totalItems = ((_items.length / crossAxisCount).ceil()) * crossAxisCount;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: Image.asset('assets/images/icon.png').image,
                  radius: 30.0,
                ),
                const SizedBox(width: 15.0),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "GLUD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        "hello@glud.com",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  iconSize: 40.0,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ),
                  ),
                  icon: const Icon(Icons.settings_rounded),
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30.0),
          Expanded(
            child: GridView.count(
              crossAxisCount: crossAxisCount,
              children: List.generate(totalItems, (index) {
                if (index < _items.length) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => _items[index].page,
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          top: (index < crossAxisCount) ? BorderSide.none : const BorderSide(color: Colors.black12, width: 1.5),
                          bottom: BorderSide.none,
                          left: (index % crossAxisCount == 0) ? BorderSide.none : const BorderSide(color: Colors.black12, width: 1.5),
                          right: BorderSide.none,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(_items[index].image, height: 40.0),
                          const SizedBox(height: 10.0),
                          Text(
                            _items[index].title,
                            style: const TextStyle(
                              fontSize: 15.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: (index < crossAxisCount) ? BorderSide.none : const BorderSide(color: Colors.black12, width: 1.5),
                        bottom: BorderSide.none,
                        left: (index % crossAxisCount == 0) ? BorderSide.none : const BorderSide(color: Colors.black12, width: 1.5),
                        right: BorderSide.none,
                      ),
                    ),
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _MypageItem {
  final String title;
  final String image;
  final Widget page;

  _MypageItem(this.title, this.image, this.page);
}

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:glud/login_pages/loginpage.dart';

import '../utility_pages/contact_page.dart';
import '../utility_pages/faq_page.dart';
import '../utility_pages/glud_list_page.dart';
import '../utility_pages/laboratory_page.dart';
import '../utility_pages/notice_page.dart';
import '../utility_pages/settings_page.dart';
import '../widgets.dart';

int globalUserType = -1;

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);

  final List<_MypageItem> _items = [
    _MypageItem(
        '내가 작성한 글', 'assets/images/mypage/recent.png', const GludListPage()),
    _MypageItem('자주 찾는 질문', 'assets/images/mypage/faq.png', const FaqPage()),
    _MypageItem(
        '고객센터', 'assets/images/mypage/contact.png', const ContactPage()),
    _MypageItem(
        '실험실', 'assets/images/mypage/laboratory.png', LaboratoryPage()),
    _MypageItem(
        '공지사항', 'assets/images/mypage/notice.png', NoticePage()),
  ];

  Future<int> getUserTypeFromFirebase() async {
    if (globalUserType == -1) {
      final usersRef = FirebaseDatabase.instance.ref();
      final snapshot = await usersRef.child('users/$usersUID/userType').get();
      int userType = snapshot.value == "Google" ? 1 : 2;
      globalUserType = userType;
      return userType;
    } else {
      return globalUserType;
    }
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 3;
    int totalItems = ((_items.length / crossAxisCount).ceil()) * crossAxisCount;
    int atIndex = usersEmail.indexOf('@');
    String name = usersEmail.substring(0, atIndex);

    return FutureBuilder<int>(
      future: getUserTypeFromFirebase(),
      builder: (BuildContext context, AsyncSnapshot<int> userType) {
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
                      backgroundImage:
                          Image.asset('assets/images/google_icon.png').image,
                      radius: 30.0,
                    ),
                    const SizedBox(width: 15.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            usersEmail,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Color(0xFF9D9D9D),
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
                      color: const Color(0xFF9D9D9D),
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
                              top: (index < crossAxisCount)
                                  ? BorderSide.none
                                  : const BorderSide(
                                      color: Colors.black12, width: 1.5),
                              bottom: BorderSide.none,
                              left: (index % crossAxisCount == 0)
                                  ? BorderSide.none
                                  : const BorderSide(
                                      color: Colors.black12, width: 1.5),
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
                            top: (index < crossAxisCount)
                                ? BorderSide.none
                                : const BorderSide(
                                    color: Colors.black12, width: 1.5),
                            bottom: BorderSide.none,
                            left: (index % crossAxisCount == 0)
                                ? BorderSide.none
                                : const BorderSide(
                                    color: Colors.black12, width: 1.5),
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
      },
    );
  }
}

class _MypageItem {
  final String title;
  final String image;
  final Widget page;

  _MypageItem(this.title, this.image, this.page);
}

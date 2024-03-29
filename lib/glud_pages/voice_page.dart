import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:glud/glud_pages/finish_page.dart';
import 'package:glud/index/menu.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../login_pages/loginpage.dart';
import '../main.dart';
import '../widgets.dart';

String content = "";
List<String> contentList = ["1", "2", "3", "4"];

String type = "";

class VoicePage extends StatefulWidget {
  const VoicePage({Key? key}) : super(key: key);

  @override
  _VoicePageState createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  final PageController _controller = PageController(initialPage: 0);
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              PageView(
                controller: _controller,
                onPageChanged: (int index) {
                  _currentPageNotifier.value = index;
                },
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  for (int i = 0; i < 4; i++)
                    buildPageWidget(i),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100.0),
                  child: ValueListenableBuilder<int>(
                    valueListenable: _currentPageNotifier,
                    builder: (BuildContext context, int currentPage, _) {
                      return _buildPageIndicator(currentPage);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPageWidget(int index) {
    onNextPage() {
      _controller.animateToPage(
        index + 1,
        duration: const Duration(milliseconds: 800),
        curve: Curves.ease,
      );
    }

    return PageWidget(
      onNextPage: onNextPage,
      pageIndex: index,
    );
  }

  Widget _buildPageIndicator(int currentPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < 4; i++)
          _buildPageDot(i == currentPage),
      ],
    );
  }

  Widget _buildPageDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      height: 10.0,
      width: 10.0,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF92B4CD) : const Color(0xFFD9D9D9),
        shape: BoxShape.circle,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    const TextStyle appBarTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
    );

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
          '음성으로 시작하기',
          style: appBarTextStyle,
        ),
      ),
      titleSpacing: -10,
      toolbarHeight: 100,
    );
  }
}

class PageWidget extends StatefulWidget {
  final int pageIndex;
  final void Function() onNextPage;

  const PageWidget({
    Key? key,
    required this.pageIndex,
    required this.onNextPage,
  }) : super(key: key);

  @override
  _PageWidgetState createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> with TickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Contents';
  double _confidence = 1.0;
  bool _showButton = false;
  bool _isCircleClicked = false;
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: const Offset(0.0, 0.15),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _speech = stt.SpeechToText();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(flex: 2, child: Container()),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: _showButton
                    ? Container(key: const ValueKey<int>(1))
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_isCircleClicked) {
                              print(
                                  "record finish\nindex : ${widget.pageIndex}");
                              contentList[widget.pageIndex] = _text;
                              _showButton = true;
                              _animationController.forward();
                            } else {
                              _listen();
                              print("record start");
                              _isCircleClicked = true;
                            }
                          });
                          print(_text);
                        },
                        child: CustomCircle(
                          isActive: _isCircleClicked,
                        ),
                      ),
              ),
              Expanded(flex: 9, child: Container()),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: _showButton
                    ? NavigationButton(
                        label: widget.pageIndex == 3 ? '완료' : '다음',
                        action: widget.pageIndex == 3
                            ? () async {
                                await write();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const FinishPage(),
                                  ),
                                );
                              }
                            : widget.onNextPage,
                      )
                    : Container(key: const ValueKey<int>(2)),
              ),
              const SizedBox(height: 160),
            ],
          ),
        ),
        SlideTransition(
          position: _offsetAnimation,
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    !_showButton
                        ? '위 버튼을 눌러서\n음성으로 입력할 수 있어요'
                        : "올바르게 입력되었다면\n${widget.pageIndex == 3 ? "'완료'를" : "'다음'을"} 눌러주세요",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    !_showButton
                        ? getPageHintText(widget.pageIndex)
                        : "글루드가 멋진 글을 완성할거예요",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9D9D9D),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Padding(
                padding: getPagePadding(widget.pageIndex),
                child: CustomContainer(
                  isHighLighted: _showButton == true ? true : null,
                  child: getPageContentText(widget.pageIndex),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _listen() async {
    if (_isListening) return;
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<String> generateText(String prompt) async {
    List<String> rolePrompt = [
      'You are a Korean journalist tasked with writing an article.',
      'You are a Korean student tasked with writing a book review.',
      'You are a Korean student who has made a mistake.'
          'You are a Korean attorney preparing to draft a lawsuit.',
    ];
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
            "content": rolePrompt[globalIndex],
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

  Future<void> likeasy() {
    return _wait();
  }

  Future<void> _wait() async {
    await write();
  }

  Future write() async {
    List<String> writingPrompt = [
      'Create a article in Korean based on the following details: An incident occurred at ${contentList[1]} on ${contentList[0]}, involving ${contentList[2]}.'
          'A pivotal figure in the event stated, "${contentList[3]}". The press release should include a headline, the date, and a concise paragraph summarizing the incident.'
          'While you may enhance the given information for dramatic effect, do not introduce any new details beyond what is inferred from the provided information.',
      'Compose a book review in Korean, incorporating the following details: date of publication: ${contentList[0]}, publisher: ${contentList[1]}, author: ${contentList[2]}, and title of the book: ${contentList[3]}.'
          'Your review should include a headline, the publication date, a summary of the book&apos;s content, and your personal opinion. Write all the information, except the headline, in a single paragraph.'
          'Feel free to embellish the provided information for impact, but do not introduce any new elements not implied by the original details.',
      'Compose a letter of apology in Korean, addressing an event described as ${contentList[3]} that occurred on ${contentList[0]} with ${contentList[2]} at ${contentList[1]}. Express deep reflection over the incident. '
          'Include in the letter the date, the person involved, the location, and a brief summary of what happened. All information, except for the title, should be written in a single paragraph. '
          'While you may intensify the provided details, refrain from adding any new elements not implied in the original information.',
      'Draft a legal complaint in Korean regarding the ${contentList[1]} that occurred on ${contentList[0]}. The lawsuit aims to achieve ${contentList[2]} and is based on the cause: ${contentList[3]}.'
          'Key elements to include are the title, date of the incident, a brief description of the incident, the objective of the lawsuit, and the underlying cause. '
          'While you may amplify the given information, refrain from introducing any new details not suggested by the original information provided.',
    ];
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
    if (globalIndex == 0) {
      type = "보도자료";
    } else if (globalIndex == 1) {
      type = "독서록";
    } else if (globalIndex == 2) {
      type = "반성문";
    } else if (globalIndex == 3) {
      type = "소송문";
    }
    String contents = await generateText(writingPrompt[globalIndex]);
    String titlePrompt =
        "Please write a Korean title for this content. ${writingPrompt[globalIndex]}.";
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
      "type": type,
    });
    databaseReference.child("users").child(usersUID).child("num").set(num);
  }

  String getPageHintText(int pageIndex) {
    switch (globalIndex) {
      case 0:
        switch (pageIndex) {
          case 0:
            return '날짜를 말해보세요';
          case 1:
            return '장소를 말해보세요';
          case 2:
            return '주요내용을 말해보세요';
          case 3:
            return '인용문을 말해보세요';
          default:
            return '';
        }
      case 1:
        switch (pageIndex) {
          case 0:
            return '작성일를 말해보세요';
          case 1:
            return '출판사를 말해보세요';
          case 2:
            return '작가명을 말해보세요';
          case 3:
            return '책 제목을 말해보세요';
          default:
            return '';
        }
      case 2:
        switch (pageIndex) {
          case 0:
            return '날짜를 말해보세요';
          case 1:
            return '장소를 말해보세요';
          case 2:
            return '사건 관련자를 말해보세요';
          case 3:
            return '주요내용을 말해보세요';
          default:
            return '';
        }
      case 3:
        switch (pageIndex) {
          case 0:
            return '날짜를 말해보세요';
          case 1:
            return '사건명을 말해보세요';
          case 2:
            return '청구 취지를 말해보세요';
          case 3:
            return '청구 원인을 말해보세요';
          default:
            return '';
        }
    }

    return 'error';
  }

  EdgeInsets getPagePadding(int pageIndex) {
    switch (globalIndex) {
      case 0:
        switch (pageIndex) {
          case 0:
            return const EdgeInsets.symmetric(horizontal: 120);
          case 1:
            return const EdgeInsets.symmetric(horizontal: 120);
          case 2:
            return const EdgeInsets.symmetric(horizontal: 50);
          case 3:
            return const EdgeInsets.symmetric(horizontal: 120);
          default:
            return const EdgeInsets.all(0);
        }
      case 1:
        switch (pageIndex) {
          case 0:
            return const EdgeInsets.symmetric(horizontal: 120);
          case 1:
            return const EdgeInsets.symmetric(horizontal: 120);
          case 2:
            return const EdgeInsets.symmetric(horizontal: 120);
          case 3:
            return const EdgeInsets.symmetric(horizontal: 120);
          default:
            return const EdgeInsets.all(0);
        }
      case 2:
        switch (pageIndex) {
          case 0:
            return const EdgeInsets.symmetric(horizontal: 120);
          case 1:
            return const EdgeInsets.symmetric(horizontal: 120);
          case 2:
            return const EdgeInsets.symmetric(horizontal: 120);
          case 3:
            return const EdgeInsets.symmetric(horizontal: 50);
          default:
            return const EdgeInsets.all(0);
        }
      case 3:
        switch (pageIndex) {
          case 0:
            return const EdgeInsets.symmetric(horizontal: 120);
          case 1:
            return const EdgeInsets.symmetric(horizontal: 120);
          case 2:
            return const EdgeInsets.symmetric(horizontal: 50);
          case 3:
            return const EdgeInsets.symmetric(horizontal: 50);
          default:
            return const EdgeInsets.all(0);
        }
    }
    return const EdgeInsets.all(0);
  }

  Widget getPageContentText(int pageIndex) {
    Widget iconAndText(String text, IconData icon) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: const Color(0xFFC0CFDB),
            size: 35,
          ),
          const SizedBox(height: 15),
          Text(
            _text,
            style: TextStyle(
              color: const Color(0xFF5E5E5E),
              fontSize: 20.0,
              fontWeight: _showButton ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    Widget result;

    switch (pageIndex) {
      case 0:
        result = iconAndText('', Icons.calendar_today);
        break;
      case 1:
        switch (globalIndex) {
          case 0:
            result = iconAndText('', Icons.place_outlined);
            break;
          case 1:
            result = iconAndText('', Icons.account_balance_outlined);
            break;
          case 2:
            result = iconAndText('', Icons.place_outlined);
            break;
          case 3:
            result = iconAndText('', Icons.search_outlined);
            break;
          default:
            result = const SizedBox();
            break;
        }
        break;
      case 2:
        switch (globalIndex) {
          case 0:
            result = Text(
              _text,
              style: TextStyle(
                color: const Color(0xFF5E5E5E),
                fontSize: 20.0,
                fontWeight: _showButton ? FontWeight.bold : FontWeight.normal,
              ),
            );
            break;
          case 1:
            result = iconAndText('', Icons.edit_outlined);
            break;
          case 2:
            result = iconAndText('', Icons.people_alt_outlined);
            break;
          case 3:
            result = Text(
              _text,
              style: TextStyle(
                color: const Color(0xFF5E5E5E),
                fontSize: 20.0,
                fontWeight: _showButton ? FontWeight.bold : FontWeight.normal,
              ),
            );
            break;
          default:
            result = const SizedBox();
            break;
        }
        break;
      case 3:
        switch (globalIndex) {
          case 0:
            result = iconAndText('', Icons.format_quote_outlined);
            break;
          case 1:
            result = iconAndText('', Icons.book_outlined);
            break;
          case 2:
          case 3:
            result = Text(
              _text,
              style: TextStyle(
                color: const Color(0xFF5E5E5E),
                fontSize: 20.0,
                fontWeight: _showButton ? FontWeight.bold : FontWeight.normal,
              ),
            );
            break;
          default:
            result = const SizedBox();
            break;
        }
        break;
      default:
        result = const SizedBox();
        break;
    }

    return result;
  }
}

class NavigationButton extends StatelessWidget {
  final String label;
  final void Function()? action;

  const NavigationButton({Key? key, required this.label, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: action,
        child: CustomContainer(
          backgroundColor: const Color(0xFF7EAAC9),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCircle extends StatelessWidget {
  final double size;
  final bool isActive;

  const CustomCircle({
    Key? key,
    this.size = 80.0,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF92B4CD) : Colors.white,
        border: Border.all(
          color: const Color(0xFF92B4CD),
          width: 2.0,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0.1,
            blurRadius: 0,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: FractionallySizedBox(
        widthFactor: 0.5,
        heightFactor: 0.5,
        child: isActive
            ? Image.asset(
                'assets/images/index/mic_active.png',
                fit: BoxFit.contain,
              )
            : Image.asset(
                'assets/images/index/mic.png',
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}

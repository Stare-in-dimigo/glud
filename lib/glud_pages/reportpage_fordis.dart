import 'package:flutter/material.dart';
import '../widgets.dart';
import 'finishpage.dart';

class ReportPageD extends StatefulWidget {
  const ReportPageD({Key? key}) : super(key: key);

  @override
  _ReportPageDState createState() => _ReportPageDState();
}

class _ReportPageDState extends State<ReportPageD> {
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
                  for (int i = 0; i < 4; i++) // Assuming 4 pages
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
        for (int i = 0; i < 4; i++) // Assuming 4 pages
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
          '보도자료',
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
  bool _showButton = false;
  bool _isCircleClicked = false;
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
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
                              _showButton = true;
                              _animationController.forward();
                            } else {
                              _isCircleClicked = true;
                            }
                          });
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
                            ? () {
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
                        : "올바르게 입력되었다면\n${widget.pageIndex == 3 ? "'완료'" : "'다음'이"}라고 말해주세요",
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
                        : "잘못된 내용이 있다면 '돌아가기'라고 말해주세요",
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

  String getPageHintText(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return '2023년 O월 O일 이라고 말해보세요';
      case 1:
        return '안산시 단원구 사세충열로 94 라고 말해보세요';
      case 2:
        return '주요 내용을 말해보세요';
      case 3:
        return '"금일 생활관 마지막 방송" 이라고 말해보세요';
      default:
        return '';
    }
  }

  EdgeInsets getPagePadding(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return const EdgeInsets.symmetric(horizontal: 130);
      case 1:
        return const EdgeInsets.symmetric(horizontal: 120);
      case 2:
        return const EdgeInsets.symmetric(horizontal: 60);
      case 3:
        return const EdgeInsets.symmetric(horizontal: 110);
      default:
        return const EdgeInsets.all(0);
    }
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
          ), // Adjust the size as needed
          const SizedBox(height: 15), // Add some spacing
          Text(
            text,
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

    switch (pageIndex) {
      case 0:
        return iconAndText('2023. 6. 6', Icons.calendar_today);
      case 1:
        return iconAndText('안산시 단원구\n사세충열로 94', Icons.place_outlined);
      case 2:
        return Text(
          '주요내용\n주요내용\n주요내용\n주요내용\n주요내용',
          style: TextStyle(
            color: const Color(0xFF5E5E5E),
            fontSize: 20.0,
            fontWeight: _showButton ? FontWeight.bold : FontWeight.normal,
          ),
        );
      case 3:
        return iconAndText('"금일 마지막 방송"', Icons.format_quote_outlined);
      default:
        return const SizedBox();
    }
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
        color: isActive ? Color(0xFF92B4CD) : Colors.white,
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

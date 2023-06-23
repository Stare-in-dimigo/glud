import 'package:flutter/material.dart';
import '../widgets.dart';

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
                children: <Widget>[
                  Page1Widget(
                    onNextPage: () {
                      _controller.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.ease,
                      );
                    },
                  ),
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

  Widget _buildPageIndicator(int currentPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < 4; i++) // Assuming 4 pages
          if (i == currentPage)
            _buildPageDot(true)
          else
            _buildPageDot(false),
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
      title: Align(
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

class Page1Widget extends StatefulWidget {
  final void Function() onNextPage;

  const Page1Widget({Key? key, required this.onNextPage}) : super(key: key);

  @override
  _Page1WidgetState createState() => _Page1WidgetState();
}

class _Page1WidgetState extends State<Page1Widget> with TickerProviderStateMixin {
  bool _showButton = false;
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: const Offset(0.0, 0.15),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
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
              _showButton
                  ? Container()
                  : GestureDetector(
                onTap: () {
                  setState(() {
                    _showButton = true;
                    _animationController.forward();
                    _fadeController.forward();
                  });
                },
                child: const CustomCircle(),
              ),
              Expanded(flex: 9, child: Container()),
              _showButton
                  ? FadeTransition(
                opacity: _fadeAnimation,
                child: NavigationButton(
                  label: '다음',
                  action: widget.onNextPage,
                ),
              )
                  : Container(),
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
                  if (!_showButton)
                    const Text(
                      '위 버튼을 눌러서\n음성으로 입력할 수 있어요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  if (_showButton)
                    const Text(
                      "올바르게 입력되었다면\n'다음'이라고 말해주세요",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (!_showButton)
                    const Text(
                      '2023년 O월 O일 이라고 말해보세요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9D9D9D),
                      ),
                    ),
                  if (_showButton)
                    const Text(
                      "잘못된 내용이 있다면 '돌아가기'라고 말해주세요",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9D9D9D),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 135),
                child: CustomContainer(
                  isHighLighted: _showButton == true ? true : null,
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFFC0CFDB),
                        size: 30,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '2023. 6. 6',
                        style: TextStyle(
                          color: const Color(0xFF5E5E5E),
                          fontSize: 20.0,
                          fontWeight: _showButton
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
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

  const CustomCircle({
    Key? key,
    this.size = 80.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFffffff),
        border: Border.all(
          color: const Color(0xFF92B4CD),
          width: 2.0,
        ),
        shape: BoxShape.circle,
      ),
      child: FractionallySizedBox(
        widthFactor: 0.5,
        heightFactor: 0.5,
        child: Image.asset(
          'assets/images/index/mic.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

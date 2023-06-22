import 'package:flutter/material.dart';
import 'package:glud/widgets.dart';
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
                children: <Widget>[
                  for (var i = 0; i < 4; i++)
                    PageViewTemplate(
                      buttonAction: i < 3
                          ? () {
                        _controller.animateToPage(
                          i + 1,
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.ease,
                        );
                      }
                          : () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FinishPage(),
                          ),
                        );
                      },
                      isLastPage: i == 3,
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

class PageViewTemplate extends StatelessWidget {
  final void Function()? buttonAction;
  final bool isLastPage;

  const PageViewTemplate({
    Key? key,
    this.buttonAction,
    this.isLastPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CustomCircle(),
        const SizedBox(height: 60),
        const Center(
          child: Column(children: [
            Text(
              '위 버튼을 눌러서\n음성으로 입력할 수 있어요',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              '2023년 O월 O일 이라고 말해보세요',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9D9D9D),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 50),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 135),
          child: CustomContainer(
            child: Column(
              children: [
                SizedBox(height: 5),
                Icon(
                  Icons.calendar_today,
                  color: Color(0xFFC0CFDB),
                  size: 30,
                ),
                SizedBox(height: 15),
                Text(
                  '2023. 6. 6',
                  style: TextStyle(
                    color: Color(0xFF5E5E5E),
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: Container()),
        NavigationButton(
          label: isLastPage ? '완료' : '다음',
          action: buttonAction,
        ),
        const SizedBox(height: 160),
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
    this.size = 80.0, // Default size is 100
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFffffff), // Inside color is white
        border: Border.all(
          color: const Color(0xFF92B4CD), // Border color
          width: 2.0, // You can adjust border width as you need
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLogin;

  LoginPage({Key? key, required this.onLogin}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  final cloudImageWidths = [150.0, 200.0, 100.0];
  final cloudBottomOffsets = [600.0, 300.0, 200.0];
  final cloudOpacities = [0.5, 0.3, 0.2];
  final cloudImagePaths = [
    'assets/images/loginpage/cloud.png',
    'assets/images/loginpage/cloud.png',
    'assets/images/loginpage/cloud.png',
  ];
  final cloudDurations = [
    const Duration(seconds: 5),
    const Duration(seconds: 6),
    const Duration(seconds: 4),
  ];

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      duration: cloudDurations[0],
      vsync: this,
    )..repeat();

    _controller2 = AnimationController(
      duration: cloudDurations[1],
      vsync: this,
    )..repeat();

    _controller3 = AnimationController(
      duration: cloudDurations[2],
      vsync: this,
    )..repeat();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFF92B4CD),
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  Widget buildCloudAnimation(int index) {
    final AnimationController controller = index == 0
        ? _controller1
        : index == 1
            ? _controller2
            : _controller3;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final opacity = cloudOpacities[index] +
            (controller.value * (1 - cloudOpacities[index]));
        final screenWidth = MediaQuery.of(context).size.width;
        final offset = Offset(
          (controller.value * (screenWidth + cloudImageWidths[index])) -
              cloudImageWidths[index],
          0,
        );

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: offset,
            child: child,
          ),
        );
      },
      child: Image.asset(
        cloudImagePaths[index],
        width: cloudImageWidths[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const cloudImageWidth = 150.0;

    return Scaffold(
      backgroundColor: const Color(0xFF92B4CD),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/icon1080.png',
                          height: 275,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    InkWell(
                      onTap: widget.onLogin,
                      child: Image.asset(
                        'assets/images/loginpage/kakao_login_large_wide.png',
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
          for (var i = 0; i < cloudImageWidths.length; i++)
            Positioned(
              bottom: cloudBottomOffsets[i],
              left: 0,
              child: buildCloudAnimation(i),
            ),
        ],
      ),
    );
  }
}

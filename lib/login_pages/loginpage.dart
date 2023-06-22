import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'registerpage.dart';
import '../widgets.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLogin;

  const LoginPage({Key? key, required this.onLogin}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  final cloudImageWidths = [150.0, 175.0, 100.0];
  final cloudBottomOffsets = [700.0, 375.0, 250.0];
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

  bool isRegistered = false;

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

    SystemChrome.setSystemUIOverlayStyle(bluestyle);
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
                      onTap: isRegistered
                          ? widget.onLogin
                          : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        ).then((value) {
                          if (value == true) {
                            widget.onLogin();
                          } else if (value == false) {
                            widget.onLogin();
                          } else {
                            SystemChrome.setSystemUIOverlayStyle(bluestyle);
                          }
                        });
                      },
                      child: CustomContainer(
                        backgroundColor: Colors.white,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/images/loginpage/google.png', width: 20.0), // Image Widget
                              const SizedBox(width: 10.0), // Spacing between image and text
                              const Text(
                                '구글로 시작하기',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: isRegistered
                          ? widget.onLogin
                          : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        ).then((value) {
                          if (value == true) {
                            widget.onLogin();
                          } else if (value == false) {
                            widget.onLogin();
                          } else {
                            SystemChrome.setSystemUIOverlayStyle(bluestyle);
                          }
                        });
                      },
                      child: CustomContainer(
                        backgroundColor: const Color(0xFFF6E24B),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/images/loginpage/kakao.png', width: 20.0), // Image Widget
                              const SizedBox(width: 10.0), // Spacing between image and text
                              const Text(
                                '카카오로 시작하기',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF381F1F),
                                ),
                              ),
                            ],
                          ),
                        ),
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

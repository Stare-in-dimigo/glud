import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glud/main.dart';
import 'package:glud/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../firebase_options.dart';
import 'registerpage.dart';

String usersUID = ""; // 현재 로그인한 사용자의 UID를 대입
String usersEmail = "";

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId: DefaultFirebaseOptions.currentPlatform.iosClientId);
  final cloudImageWidths = [150.0, 175.0, 100.0];
  final cloudBottomOffsets = [700.0, 350.0, 200.0];
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

    SystemChrome.setSystemUIOverlayStyle(statusbarStyle);
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

  void _handleGoogleSignIn() async {
    int regist = 0;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      //이메일과 UID 가져오기
      final String userEmail = user?.email ?? '';
      final String userUID = user?.uid ?? '';
      usersUID = user?.uid ?? '';
      usersEmail = user?.email ?? '';
      String userType = "Google";
      final DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users').child(userUID);
      final DataSnapshot snapshot =
          await userRef.once().then((event) => event.snapshot);
      if (!snapshot.exists) {
        // 데이터베이스에 사용자 UID가 없으면 저장
        regist = 1;
        await userRef.child('email').set(userEmail);
        await userRef.child('userType').set(userType);
        await userRef.child('isDisabled').set(isDisabled);
      }
      if (regist == 0) {
        // 이미 회원가입한 사용자라면 회원가입을 건너뜀
        widget.onLogin();
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterPage()),
        ).then((value) {
          if (value == true) {
            widget.onLogin();
          } else if (value == false) {
            widget.onLogin();
          } else {
            SystemChrome.setSystemUIOverlayStyle(statusbarStyle);
          }
        });
      }
    } catch (e) {
      // 로그인 실패 시 예외 처리
      print('Google Sign-In Error: $e');
    }
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
                    const SizedBox(height: 50),
                    InkWell(
                      onTap:
                          isRegistered ? widget.onLogin : _handleGoogleSignIn,
                      child: CustomContainer(
                        backgroundColor: Colors.white,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/images/loginpage/google.png',
                                  width: 20.0), // Image Widget
                              const SizedBox(width: 10.0),
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final bool? isHighLighted;
  final BorderRadius? borderRadius;

  const CustomContainer({
    Key? key,
    required this.child,
    this.height,
    this.isHighLighted,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isHighLighted != null && isHighLighted!) {
      return Container(
        height: height,
        width: double.infinity,
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          border: Border.all(
            color: const Color(0xFF7EAAC9),
            width: 2,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0.1,
              blurRadius: 0,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: child,
      );
    } else {
      return Container(
        height: height,
        width: double.infinity,
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xFFF5F5F5),
          borderRadius: borderRadius ?? BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0.1,
              blurRadius: 0,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: child,
      );
    }
  }
}

class CustomLoading extends StatelessWidget {
  const CustomLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        // 모서리에 곡률을 줍니다
        borderRadius: BorderRadius.circular(15), // 곡률의 정도를 조절합니다
      ),
      child: Container(
        width: 200, // Dialog의 너비를 지정합니다
        padding: const EdgeInsets.all(40),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30.0, // 원하는 높이
              width: 30.0, // 원하는 너비
              child: CircularProgressIndicator(
                color: Color(0xFFC0CFDB),
                strokeWidth: 4.0,
              ),
            ),
            SizedBox(width: 20),
            Text(
              '로딩중...',
              style: TextStyle(
                color: Color(0xFF5E5E5E),
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

const SystemUiOverlayStyle statusbarStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark,
);

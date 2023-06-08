import 'package:flutter/material.dart';

const titleTextStyle = TextStyle(
  fontSize: 30.0,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const regularTextStyle = TextStyle(
  fontSize: 20.0,
  color: Color(0xFFB1B8C0),
);

const buttonTextStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

class CustomContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const CustomContainer(
      {Key? key,
        required this.child,
        this.height,
        this.backgroundColor,
        this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
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

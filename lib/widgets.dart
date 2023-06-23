import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final bool? isHighLighted;

  const CustomContainer({
    Key? key,
    required this.child,
    this.height,
    this.isHighLighted,
    this.backgroundColor,
    this.padding,
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
          borderRadius: BorderRadius.circular(20),
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
          borderRadius: BorderRadius.circular(20),
        ),
        child: child,
      );
    }
  }
}


class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

const SystemUiOverlayStyle bluestyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  systemNavigationBarColor: Color(0xFF92B4CD),
  statusBarIconBrightness: Brightness.dark,
);

const SystemUiOverlayStyle whitestyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  systemNavigationBarColor: Colors.white,
  statusBarIconBrightness: Brightness.dark,
);

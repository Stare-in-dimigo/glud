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
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 5,
        color: Color(0xFFC0CFDB),
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

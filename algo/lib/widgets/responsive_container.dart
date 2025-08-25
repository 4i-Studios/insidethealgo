import 'package:flutter/material.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final Border? border;
  final Gradient? gradient;
  final double? width;
  final double? height;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.borderRadius,
    this.border,
    this.gradient,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.all(isTablet ? 20 : 16),
      margin: margin ?? EdgeInsets.all(isTablet ? 12 : 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: gradient,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        border: border,
      ),
      child: child,
    );
  }
}
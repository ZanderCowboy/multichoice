import 'package:flutter/material.dart';

class CircularLoader extends StatelessWidget {
  const CircularLoader._({
    super.key,
    required this.size,
    required this.strokeWidth,
    this.value,
    this.backgroundColor,
    this.color,
    this.valueColor,
    this.strokeAlign = CircularProgressIndicator.strokeAlignCenter,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeCap,
    this.shouldCenter = true,
  });

  final double size;
  final double strokeWidth;
  final double? value;
  final Color? backgroundColor;
  final Color? color;
  final Animation<Color?>? valueColor;
  final double strokeAlign;
  final String? semanticsLabel;
  final String? semanticsValue;
  final StrokeCap? strokeCap;
  final bool shouldCenter;

  /// Creates a small loader (32x32 with 4px stroke)
  factory CircularLoader.small({
    Key? key,
    double? value,
    Color? backgroundColor,
    Color? color,
    Animation<Color?>? valueColor,
    double strokeWidth = 4.0,
    double strokeAlign = CircularProgressIndicator.strokeAlignCenter,
    String? semanticsLabel,
    String? semanticsValue,
    StrokeCap? strokeCap,
    bool shouldCenter = true,
  }) {
    return CircularLoader._(
      key: key,
      size: 32.0,
      strokeWidth: strokeWidth,
      value: value,
      backgroundColor: backgroundColor,
      color: color,
      valueColor: valueColor,
      strokeAlign: strokeAlign,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      strokeCap: strokeCap,
      shouldCenter: shouldCenter,
    );
  }

  /// Creates a medium loader (48x48 with 6px stroke)
  factory CircularLoader.medium({
    Key? key,
    double? value,
    Color? backgroundColor,
    Color? color,
    Animation<Color?>? valueColor,
    double strokeWidth = 6.0,
    double strokeAlign = CircularProgressIndicator.strokeAlignCenter,
    String? semanticsLabel,
    String? semanticsValue,
    StrokeCap? strokeCap,
    bool shouldCenter = true,
  }) {
    return CircularLoader._(
      key: key,
      size: 48.0,
      strokeWidth: strokeWidth,
      value: value,
      backgroundColor: backgroundColor,
      color: color,
      valueColor: valueColor,
      strokeAlign: strokeAlign,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      strokeCap: strokeCap,
      shouldCenter: shouldCenter,
    );
  }

  /// Creates a large loader (64x64 with 8px stroke)
  factory CircularLoader.large({
    Key? key,
    double? value,
    Color? backgroundColor,
    Color? color,
    Animation<Color?>? valueColor,
    double strokeWidth = 8.0,
    double strokeAlign = CircularProgressIndicator.strokeAlignCenter,
    String? semanticsLabel,
    String? semanticsValue,
    StrokeCap? strokeCap,
    bool shouldCenter = true,
  }) {
    return CircularLoader._(
      key: key,
      size: 64.0,
      strokeWidth: strokeWidth,
      value: value,
      backgroundColor: backgroundColor,
      color: color,
      valueColor: valueColor,
      strokeAlign: strokeAlign,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      strokeCap: strokeCap,
      shouldCenter: shouldCenter,
    );
  }

  /// Creates a custom loader with specified dimensions
  factory CircularLoader.custom({
    Key? key,
    required double size,
    double? value,
    Color? backgroundColor,
    Color? color,
    Animation<Color?>? valueColor,
    required double strokeWidth,
    double strokeAlign = CircularProgressIndicator.strokeAlignCenter,
    String? semanticsLabel,
    String? semanticsValue,
    StrokeCap? strokeCap,
    bool shouldCenter = true,
  }) {
    return CircularLoader._(
      key: key,
      size: size,
      strokeWidth: strokeWidth,
      value: value,
      backgroundColor: backgroundColor,
      color: color,
      valueColor: valueColor,
      strokeAlign: strokeAlign,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      strokeCap: strokeCap,
      shouldCenter: shouldCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loader = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value,
        backgroundColor: backgroundColor,
        valueColor: valueColor ??
            (color != null ? AlwaysStoppedAnimation<Color>(color!) : null),
        strokeWidth: strokeWidth,
        strokeAlign: strokeAlign,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
        strokeCap: strokeCap,
      ),
    );

    return shouldCenter ? Center(child: loader) : loader;
  }
}

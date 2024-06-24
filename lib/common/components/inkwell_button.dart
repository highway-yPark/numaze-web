import 'package:flutter/material.dart';
import 'package:numaze_web/common/const/colors.dart';

class InkwellButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final String text;
  final Color fontColor;

  const InkwellButton({
    super.key,
    required this.onTap,
    required this.color,
    required this.text,
    required this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          color: color,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: fontColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BlackInkwellButton extends InkwellButton {
  const BlackInkwellButton({
    super.key,
    required super.onTap,
    required super.text,
  }) : super(
          color: ContainerColors.black,
          fontColor: FontColors
              .white, // Ensure FontColors.white is defined in colors.dart
        );
}

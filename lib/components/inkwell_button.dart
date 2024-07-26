import 'package:flutter/material.dart';
import 'package:numaze_web/common/const/colors.dart';
import 'package:numaze_web/common/const/text.dart';

class InkwellButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final String text;
  final TextStyle style;

  const InkwellButton({
    super.key,
    required this.onTap,
    required this.color,
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Ink(
            color: color,
            child: Center(
              child: Text(
                text,
                style: style,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BlackInkwellButton extends InkwellButton {
  BlackInkwellButton({
    super.key,
    required super.onTap,
    required super.text,
  }) : super(
          color: ContainerColors.black,
          style: TextDesign.bold18W,
        );
}

class ConditionalInkwellButton extends InkwellButton {
  final bool condition;

  ConditionalInkwellButton({
    super.key,
    required super.onTap,
    required super.text,
    required this.condition,
  }) : super(
          color: condition ? ContainerColors.ctaGrey : ContainerColors.black,
          style: TextDesign.bold18W,
        );
}

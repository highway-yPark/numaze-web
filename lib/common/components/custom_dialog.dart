import 'package:flutter/material.dart';
import 'package:numaze_web/common/const/colors.dart';
import 'package:numaze_web/common/const/data.dart';
import 'package:numaze_web/common/const/text.dart';

import 'inkwell_button.dart';

class CustomDialog extends StatelessWidget {
  final String subject;
  final double width;
  final String title;
  final Widget? child;

  const CustomDialog({
    super.key,
    required this.subject,
    required this.width,
    required this.title,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        color: Colors.white,
        width: width * ConstValues.dialogWidthPercentage,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Container(
              width: 96,
              height: 25,
              decoration: const BoxDecoration(
                color: BrandColors.orange,
              ),
              child: Center(
                child: Text(
                  subject,
                  style: TextDesign.bold18W,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (child != null) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: child!,
              ),
            ],
            const SizedBox(height: 16),
            BlackInkwellButton(
              onTap: () {
                Navigator.pop(context);
              },
              text: '확인',
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:numaze_web/common/const/colors.dart';
import 'package:numaze_web/common/const/data.dart';
import 'package:numaze_web/common/const/text.dart';

import 'inkwell_button.dart';

class CustomDialog extends StatelessWidget {
  final String subject;
  final double width;
  final String title;
  final String content;

  const CustomDialog({
    super.key,
    required this.subject,
    required this.width,
    required this.title,
    required this.content,
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
                color: BrandColors.pink,
              ),
              child: Center(
                child: Text(
                  subject,
                  style: TextDesign.bold18W,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                title,
                style: TextDesign.bold18B,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 15),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      content,
                      style: TextDesign.regular14G,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              color: ContainerColors.black,
              height: 57,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Ink(
                  color: ContainerColors.black,
                  child: Center(
                    child: Text(
                      '확인',
                      style: TextDesign.bold16W,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

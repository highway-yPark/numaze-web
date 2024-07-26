import 'package:flutter/material.dart';
import 'package:numaze_web/common/const/text.dart';

import '../common/const/icons.dart';

void customSnackBar({
  required String message,
  required BuildContext context,
  bool error = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height *
            0.15, // Adjust the value as needed
        left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
      duration: const Duration(
        seconds: 1,
      ),
      content: Row(
        children: [
          if (error) CommonIcons.redError() else CommonIcons.whiteCheck(),
          const SizedBox(
            width: 8,
          ), // Add some space between the icon and the text.
          Text(
            message,
            style: TextDesign.medium14W,
          ),
        ],
      ),
    ),
  );
}

void onlyOneSnackBar({
  required BuildContext context,
  // String message = '같은 카테고리의 시술을 2개 이상 담을 수 없어요.',
  required String message,
  bool error = true,
}) {
  customSnackBar(
    message: '$message에는 하나의 시술만 선택할 수 있어요.',
    context: context,
    error: error,
  );
}

void copySnackBar({
  required BuildContext context,
  String message = '복사했어요.',
  bool error = false,
}) {
  customSnackBar(
    message: message,
    context: context,
    error: error,
  );
}

void errorSnackBar({
  required BuildContext context,
  String message = '오류가 발생했어요.',
  bool error = true,
}) {
  customSnackBar(
    message: message,
    context: context,
    error: error,
  );
}

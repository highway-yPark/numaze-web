// custom snackbar
// ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
// content:
// Text('You can only select one treatment per category.')));

import 'package:flutter/material.dart';
import 'package:numaze_web/common/const/text.dart';

void customSnackBar({
  required String message,
  required BuildContext context,
  bool error = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height *
            0.1, // Adjust the value as needed
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
      duration: const Duration(
        seconds: 1,
      ),
      content: Row(
        children: [
          const Icon(
            Icons.alarm,
            color: Colors.red,
          ),
          Text(
            message,
            style: TextDesign.regular16W,
          ),
        ],
      ),
    ),
  );
}

void onlyOneSnackBar({
  required BuildContext context,
  String message = '같은 카테고리의 시술을 2개 이상 담을 수 없어요.',
  bool error = true,
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

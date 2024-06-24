// custom snackbar
// ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
// content:
// Text('You can only select one treatment per category.')));

import 'package:flutter/material.dart';
import 'package:numaze_web/common/const/text.dart';

void customSnackBar(
  String message,
  BuildContext context,
) =>
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

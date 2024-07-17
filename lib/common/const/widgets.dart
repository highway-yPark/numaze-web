import 'package:flutter/material.dart';

import 'colors.dart';
import 'text.dart';

// class CustomDivider extends StatelessWidget {
//   final double height;
//   final Color color;
//
//   const CustomDivider({
//     super.key,
//     this.height = 1.0,
//     this.color = AppColors.lightGrey,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Divider(
//       height: height,
//       color: color,
//     );
//   }
// }

class ConstWidgets {
  static greyBox() {
    return Container(
      color: ContainerColors.mediumGrey,
      height: 8,
    );
  }

  static homeScreenDivider() {
    return Container(
      color: AppColors.black,
      height: 4,
    );
  }
}

class CommonWidgets {
  static headingBox(String text) {
    return SizedBox(
      height: 62,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: TextDesign.bold22B,
          ),
        ),
      ),
    );
  }

  static customDivider(Color color) {
    return Container(
      color: color,
      height: 1,
    );
  }

  static commonDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: StrokeColors.grey,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(3.0),
      // color: ContainerColors.white,
    );
  }

  static sixteenTenPadding() {
    return const EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 16,
    );
  }

  static greyBorder(Color color) {
    return BoxDecoration(
      border: Border.all(
        color: StrokeColors.grey,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(3.0),
      color: color,
    );
  }

  static ctaPadding() {
    return const EdgeInsets.only(
      top: 14,
      bottom: 15,
      left: 20,
      right: 20,
    );
  }
}

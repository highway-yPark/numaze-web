import 'package:flutter/cupertino.dart';

import 'common/const/text.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  // final VoidCallback onTap;
  // final Widget? rightWidget;

  const CommonAppBar({
    super.key,
    required this.title,
    // required this.onTap,
    // this.rightWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Text(
          title,
          style: TextDesign.bold18B,
        ),
      ),
      // Stack(
      //   children: [
      //     Align(
      //         alignment: Alignment.centerLeft,
      //         child: GestureDetector(
      //           onTap: onTap,
      //           child: const Icon(
      //             CupertinoIcons.arrow_left,
      //             color: IconColors.black,
      //           ),
      //         )),
      //     Center(
      //       child: Text(
      //         title,
      //         style: TextDesign.bold18B,
      //       ),
      //     ),
      //     Align(
      //       alignment: Alignment.centerRight,
      //       child: rightWidget ?? const SizedBox(),
      //     ),
      //   ],
      // ),
    );
  }
}

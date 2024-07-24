import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import 'common/const/icons.dart';
import 'common/const/text.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final String shopDomain;
  // final VoidCallback onTap;
  // final Widget? rightWidget;

  const CommonAppBar({
    super.key,
    required this.title,
    required this.shopDomain,
    // required this.onTap,
    // this.rightWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                context.go('/s/$shopDomain');
                // Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: CommonIcons.home(),
            ),
          ),
          Center(
            child: Text(
              title,
              style: TextDesign.bold18B,
            ),
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: SizedBox(),
          ),
        ],
      ),
    );
    // return Container(
    //   height: 52,
    //   padding: const EdgeInsets.symmetric(horizontal: 16),
    //   child: Center(
    //     child: Text(
    //       title,
    //       style: TextDesign.bold18B,
    //     ),
    //   ),
    // );
  }
}

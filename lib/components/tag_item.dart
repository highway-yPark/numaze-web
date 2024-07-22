import 'package:flutter/material.dart';

import '../common/const/colors.dart';
import '../common/const/text.dart';

class TagItem extends StatelessWidget {
  final String tag;

  const TagItem({
    super.key,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: ContainerColors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: StrokeColors.black,
          width: 1,
        ),
      ),
      child: Text(
        tag,
        style: TextDesign.regular12B,
      ),
    );
  }
}
